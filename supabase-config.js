// ============================================================
//  NEU Library — Supabase Configuration
//  Replace SUPABASE_URL and SUPABASE_ANON_KEY with your values
// ============================================================

const SUPABASE_URL = 'https://YOUR_PROJECT_ID.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR_ANON_KEY_HERE';

const { createClient } = supabase;
const db = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// ============================================================
//  College & Program Data
// ============================================================
const NEU_DATA = {
  colleges: [
    {
      id: 'CAS',
      name: 'College of Arts and Sciences',
      programs: [
        'Bachelor of Science in Biology',
        'Bachelor of Science in Psychology',
        'Bachelor of Arts in Communication',
        'Bachelor of Arts in English Language Studies',
        'Bachelor of Science in Mathematics',
      ]
    },
    {
      id: 'CBM',
      name: 'College of Business and Management',
      programs: [
        'Bachelor of Science in Accountancy',
        'Bachelor of Science in Business Administration major in Financial Management',
        'Bachelor of Science in Business Administration major in Marketing Management',
        'Bachelor of Science in Business Administration major in Human Resource Management',
        'Bachelor of Science in Office Administration',
      ]
    },
    {
      id: 'CEA',
      name: 'College of Engineering and Architecture',
      programs: [
        'Bachelor of Science in Civil Engineering',
        'Bachelor of Science in Computer Engineering',
        'Bachelor of Science in Electrical Engineering',
        'Bachelor of Science in Electronics Engineering',
        'Bachelor of Science in Mechanical Engineering',
        'Bachelor of Science in Architecture',
      ]
    },
    {
      id: 'CCS',
      name: 'College of Computer Studies',
      programs: [
        'Bachelor of Science in Computer Science',
        'Bachelor of Science in Information Technology',
        'Bachelor of Science in Information Systems',
      ]
    },
    {
      id: 'CED',
      name: 'College of Education',
      programs: [
        'Bachelor of Elementary Education',
        'Bachelor of Secondary Education major in English',
        'Bachelor of Secondary Education major in Mathematics',
        'Bachelor of Secondary Education major in Science',
        'Bachelor of Secondary Education major in Filipino',
        'Bachelor of Physical Education',
      ]
    },
    {
      id: 'CHM',
      name: 'College of Hospitality Management',
      programs: [
        'Bachelor of Science in Hospitality Management',
        'Bachelor of Science in Tourism Management',
      ]
    },
    {
      id: 'CN',
      name: 'College of Nursing',
      programs: [
        'Bachelor of Science in Nursing',
      ]
    },
    {
      id: 'CCJ',
      name: 'College of Criminal Justice',
      programs: [
        'Bachelor of Science in Criminology',
      ]
    },
    {
      id: 'CAFA',
      name: 'College of Architecture and Fine Arts',
      programs: [
        'Bachelor of Fine Arts major in Advertising Arts',
        'Bachelor of Fine Arts major in Industrial Design',
        'Bachelor of Fine Arts major in Painting',
      ]
    },
    {
      id: 'SHS',
      name: 'Senior High School',
      programs: [
        'STEM (Science, Technology, Engineering, Mathematics)',
        'ABM (Accountancy, Business, and Management)',
        'HUMSS (Humanities and Social Sciences)',
        'GAS (General Academic Strand)',
        'TVL (Technical-Vocational-Livelihood)',
      ]
    },
  ],

  adminOffices: [
    'Office of the President',
    'Office of the Vice President for Academic Affairs',
    'Office of the Vice President for Administration',
    'Registrar\'s Office',
    'Admissions Office',
    'Finance Office / Cashier',
    'Human Resources Department',
    'Information Technology Center',
    'Research and Development Office',
    'Student Affairs and Services',
    'Library Services',
    'Guidance and Counseling Center',
    'Physical Plant and Facilities',
    'Public Relations Office',
    'Alumni Affairs Office',
    'Medical and Dental Clinic',
    'Security Office',
    'Maintenance Department',
    'Canteen / Food Services',
    'Bookstore',
  ]
};

// ============================================================
//  Utility Helpers
// ============================================================
function formatDateTime(iso) {
  if (!iso) return '—';
  return new Date(iso).toLocaleString('en-PH', {
    month: 'short', day: '2-digit', year: 'numeric',
    hour: '2-digit', minute: '2-digit', hour12: true
  });
}

function formatTime(iso) {
  if (!iso) return '—';
  return new Date(iso).toLocaleTimeString('en-PH', {
    hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true
  });
}

function formatDate(iso) {
  if (!iso) return '—';
  return new Date(iso).toLocaleDateString('en-PH', {
    month: 'long', day: '2-digit', year: 'numeric'
  });
}

function getDwellMinutes(timeIn, timeOut) {
  if (!timeIn || !timeOut) return null;
  return Math.round((new Date(timeOut) - new Date(timeIn)) / 60000);
}

function formatDwell(minutes) {
  if (!minutes) return '—';
  const h = Math.floor(minutes / 60);
  const m = minutes % 60;
  if (h === 0) return `${m}m`;
  return `${h}h ${m}m`;
}

// ============================================================
//  ID / Email Validation
// ============================================================
function validateID(id) {
  const student = /^\d{2}-\d{5}-\d{3}$/;
  const faculty  = /^F\d+$/i;
  const employee = /^E\d+$/i;
  return student.test(id) || faculty.test(id) || employee.test(id);
}

function validateAdminID(id) {
  return /^A\d+$/i.test(id);  // Format: A001, A002, A010, etc.
}

function validateNEUEmail(email) {
  return /@neu\.edu\.ph$/i.test(email);
}
