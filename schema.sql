-- ============================================================
--  NEU Library Visitor Log System — Supabase SQL Schema
--  Run this in your Supabase SQL Editor (Dashboard → SQL Editor)
-- ============================================================

-- ────────────────────────────────────────────────────────────
--  TABLE 1: profiles
--  Stores all users (students, faculty, employees, admins)
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.profiles (
  id               TEXT        PRIMARY KEY,        -- e.g. 24-00001-001, F0001, E0001, AX-00001-001
  first_name       TEXT        NOT NULL,
  middle_initial   TEXT,                           -- optional, e.g. 'D'
  last_name        TEXT        NOT NULL,
  email            TEXT        NOT NULL UNIQUE,    -- must be @neu.edu.ph
  user_type        TEXT        NOT NULL            -- 'Student' | 'Faculty' | 'Employee'
                   CHECK (user_type IN ('Student', 'Faculty', 'Employee')),
  role             TEXT        NOT NULL DEFAULT 'user'  -- 'user' | 'admin'
                   CHECK (role IN ('user', 'admin')),
  college_dept     TEXT,                           -- College name (students) or Office name (faculty/employee)
  program          TEXT,                           -- Program name (students only)
  status           TEXT        NOT NULL DEFAULT 'active'
                   CHECK (status IN ('active', 'blocked')),
  password         TEXT,                           -- For admins only (store hashed in production!)
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index for quick lookup by email
CREATE INDEX IF NOT EXISTS idx_profiles_email     ON public.profiles (email);
CREATE INDEX IF NOT EXISTS idx_profiles_user_type ON public.profiles (user_type);
CREATE INDEX IF NOT EXISTS idx_profiles_role      ON public.profiles (role);
CREATE INDEX IF NOT EXISTS idx_profiles_status    ON public.profiles (status);

-- ────────────────────────────────────────────────────────────
--  TABLE 2: visitor_logs
--  Records every visit (check-in and check-out)
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.visitor_logs (
  log_id           BIGSERIAL   PRIMARY KEY,
  user_id          TEXT        NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  purpose          TEXT        NOT NULL
                   CHECK (purpose IN (
                     'Study', 'Research', 'Borrow/Return Books',
                     'PC/Internet Usage', 'Meeting', 'Duty/Work',
                     'Official Business', 'Others'
                   )),
  specific_purpose TEXT,                           -- Filled when purpose = 'Others'
  time_in          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  time_out         TIMESTAMPTZ,                    -- NULL while visitor is still inside
  status           TEXT        NOT NULL DEFAULT 'IN'
                   CHECK (status IN ('IN', 'OUT')),
  date             DATE        NOT NULL DEFAULT CURRENT_DATE  -- for easy daily filtering
);

-- Indexes for dashboard queries
CREATE INDEX IF NOT EXISTS idx_logs_user_id  ON public.visitor_logs (user_id);
CREATE INDEX IF NOT EXISTS idx_logs_date     ON public.visitor_logs (date);
CREATE INDEX IF NOT EXISTS idx_logs_status   ON public.visitor_logs (status);
CREATE INDEX IF NOT EXISTS idx_logs_purpose  ON public.visitor_logs (purpose);
CREATE INDEX IF NOT EXISTS idx_logs_time_in  ON public.visitor_logs (time_in DESC);

-- ────────────────────────────────────────────────────────────
--  ROW LEVEL SECURITY (RLS)
--  Enable RLS and create policies so the anon key can read/write
--  (adjust these policies to be more restrictive in production)
-- ────────────────────────────────────────────────────────────

-- Enable RLS
ALTER TABLE public.profiles     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.visitor_logs ENABLE ROW LEVEL SECURITY;

-- profiles: allow anon to select (for login lookup), insert (registration), update (admin actions)
DROP POLICY IF EXISTS "allow_anon_select_profiles"  ON public.profiles;
DROP POLICY IF EXISTS "allow_anon_insert_profiles"  ON public.profiles;
DROP POLICY IF EXISTS "allow_anon_update_profiles"  ON public.profiles;
DROP POLICY IF EXISTS "allow_anon_delete_profiles"  ON public.profiles;

CREATE POLICY "allow_anon_select_profiles"
  ON public.profiles FOR SELECT TO anon USING (true);

CREATE POLICY "allow_anon_insert_profiles"
  ON public.profiles FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "allow_anon_update_profiles"
  ON public.profiles FOR UPDATE TO anon USING (true) WITH CHECK (true);

CREATE POLICY "allow_anon_delete_profiles"
  ON public.profiles FOR DELETE TO anon USING (true);

-- visitor_logs: same open policy for the demo app
DROP POLICY IF EXISTS "allow_anon_select_logs" ON public.visitor_logs;
DROP POLICY IF EXISTS "allow_anon_insert_logs" ON public.visitor_logs;
DROP POLICY IF EXISTS "allow_anon_update_logs" ON public.visitor_logs;
DROP POLICY IF EXISTS "allow_anon_delete_logs" ON public.visitor_logs;

CREATE POLICY "allow_anon_select_logs"
  ON public.visitor_logs FOR SELECT TO anon USING (true);

CREATE POLICY "allow_anon_insert_logs"
  ON public.visitor_logs FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "allow_anon_update_logs"
  ON public.visitor_logs FOR UPDATE TO anon USING (true) WITH CHECK (true);

CREATE POLICY "allow_anon_delete_logs"
  ON public.visitor_logs FOR DELETE TO anon USING (true);

-- ────────────────────────────────────────────────────────────
--  SEED DATA — Default Super Admin Account
--  ⚠️  CHANGE THE PASSWORD BEFORE DEPLOYING TO PRODUCTION!
--  In production, use Supabase Auth instead of plain passwords.
-- ────────────────────────────────────────────────────────────
INSERT INTO public.profiles (
  id, first_name, last_name, email, user_type, role,
  college_dept, status, password, created_at
) VALUES (
  'AX-00001-001',
  'Library',
  'Admin',
  'libadmin@neu.edu.ph',
  'Employee',
  'admin',
  'Library Services',
  'active',
  'Admin@12345',          -- ⚠️ Change this immediately in production!
  NOW()
)
ON CONFLICT (id) DO NOTHING;

-- ────────────────────────────────────────────────────────────
--  HELPFUL VIEWS (optional — for reporting)
-- ────────────────────────────────────────────────────────────

-- View: daily summary
CREATE OR REPLACE VIEW public.v_daily_summary AS
SELECT
  date,
  COUNT(*)                                            AS total_visits,
  COUNT(*) FILTER (WHERE status = 'IN')               AS currently_inside,
  COUNT(*) FILTER (WHERE p.user_type = 'Student')     AS student_visits,
  COUNT(*) FILTER (WHERE p.user_type = 'Faculty')     AS faculty_visits,
  COUNT(*) FILTER (WHERE p.user_type = 'Employee')    AS employee_visits,
  ROUND(AVG(EXTRACT(EPOCH FROM (time_out - time_in)) / 60)
        FILTER (WHERE time_out IS NOT NULL))::INT      AS avg_dwell_minutes
FROM public.visitor_logs vl
JOIN public.profiles p ON p.id = vl.user_id
GROUP BY date
ORDER BY date DESC;

-- View: active visitors (currently inside)
CREATE OR REPLACE VIEW public.v_active_visitors AS
SELECT
  vl.log_id,
  vl.user_id,
  p.first_name,
  p.middle_initial,
  p.last_name,
  p.email,
  p.user_type,
  p.college_dept,
  p.program,
  vl.purpose,
  vl.specific_purpose,
  vl.time_in,
  vl.date,
  EXTRACT(EPOCH FROM (NOW() - vl.time_in)) / 60  AS minutes_inside
FROM public.visitor_logs vl
JOIN public.profiles p ON p.id = vl.user_id
WHERE vl.status = 'IN'
ORDER BY vl.time_in DESC;

-- ────────────────────────────────────────────────────────────
--  QUICK REFERENCE
-- ────────────────────────────────────────────────────────────
/*
  Tables:
    public.profiles       — user accounts (students, faculty, employees, admins)
    public.visitor_logs   — visit records with check-in / check-out

  Views:
    public.v_daily_summary    — aggregated daily stats
    public.v_active_visitors  — people currently inside

  ID Formats:
    Student:  XX-XXXXX-XXX   e.g. 24-00001-001
    Faculty:  F<number>       e.g. F0001
    Employee: E<number>       e.g. E0001
    Admin:    AX-XXXXX-XXX    e.g. AX-00001-001

  Default Admin Credentials:
    ID:       AX-00001-001
    Email:    libadmin@neu.edu.ph
    Password: Admin@12345    ← CHANGE BEFORE GOING LIVE

  ⚠️  Production Checklist:
  1. Replace plain-text password with Supabase Auth (signInWithPassword)
  2. Tighten RLS policies — don't allow anon to delete profiles in production
  3. Replace SUPABASE_URL and SUPABASE_ANON_KEY in supabase-config.js
  4. Host files on a web server (VS Code Live Server, Netlify, Vercel, etc.)
*/
