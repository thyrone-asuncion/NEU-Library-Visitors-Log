-- ============================================================
--  NEU Library — SQL Fixes
--  Run these in Supabase → SQL Editor
-- ============================================================


-- ────────────────────────────────────────────────────────
--  FIX 1: Manual checkout of your stuck March 17 record
--  Run this NOW to log out the record that is stuck as IN
-- ────────────────────────────────────────────────────────
UPDATE public.visitor_logs
SET
  time_out = '2026-03-17 23:59:00+08',   -- sets checkout to 11:59 PM March 17 PH time
  status   = 'OUT'
WHERE
  status = 'IN'
  AND date < CURRENT_DATE AT TIME ZONE 'Asia/Manila';
-- This safely closes ALL old open records from previous days


-- ────────────────────────────────────────────────────────
--  FIX 2: Midnight Auto-Checkout using pg_cron
--
--  This runs every day at midnight Philippine Time (4:00 PM UTC)
--  and automatically checks out anyone still marked as IN
--  from the previous day.
--
--  Step 1: Enable pg_cron extension (run this first)
-- ────────────────────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS pg_cron;


-- ────────────────────────────────────────────────────────
--  Step 2: Create the auto-checkout function
-- ────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.auto_checkout_midnight()
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
  ph_today DATE;
BEGIN
  -- Get today's date in Philippine Time (UTC+8)
  ph_today := (NOW() AT TIME ZONE 'Asia/Manila')::DATE;

  -- Close all IN records from BEFORE today
  UPDATE public.visitor_logs
  SET
    time_out = (date::TIMESTAMP + INTERVAL '23 hours 59 minutes') AT TIME ZONE 'Asia/Manila',
    status   = 'OUT'
  WHERE
    status = 'IN'
    AND date < ph_today;

  RAISE NOTICE 'Auto-checkout complete for dates before %', ph_today;
END;
$$;


-- ────────────────────────────────────────────────────────
--  Step 3: Schedule it to run every day at midnight PH time
--  Midnight PH (UTC+8) = 16:00 UTC
-- ────────────────────────────────────────────────────────
SELECT cron.schedule(
  'midnight-auto-checkout',       -- job name (unique)
  '0 16 * * *',                   -- every day at 16:00 UTC = 12:00 AM Philippine Time
  'SELECT public.auto_checkout_midnight();'
);


-- ────────────────────────────────────────────────────────
--  To verify the cron job was created, run:
-- ────────────────────────────────────────────────────────
-- SELECT * FROM cron.job;


-- ────────────────────────────────────────────────────────
--  To manually test the auto-checkout right now:
-- ────────────────────────────────────────────────────────
-- SELECT public.auto_checkout_midnight();


-- ────────────────────────────────────────────────────────
--  NOTE: If pg_cron is not available on your Supabase plan,
--  you can alternatively use a Supabase Edge Function
--  triggered by a cron schedule in the dashboard under
--  Edge Functions → Schedule.
--
--  The Edge Function body would simply call:
--    await supabase.rpc('auto_checkout_midnight')
-- ────────────────────────────────────────────────────────
