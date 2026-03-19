# NEU Library Visitor Log System

**New Era University — Library Services**
A web-based Library Visitor Log System for tracking student, faculty, and employee visits to the NEU Library.

---

## Live Site

**Main Link:** https://neu-library-visitors-log-system.vercel.app/

| Page | URL |
|---|---|
| **Visitor Login / Logout** | https://neu-library-visitors-log-system.vercel.app/ |
| **Registration** | https://neu-library-visitors-log-system.vercel.app/register.html |
| **Admin Login** | https://neu-library-visitors-log-system.vercel.app/admin-login.html |
| **Admin Dashboard** | https://neu-library-visitors-log-system.vercel.app/admin-dashboard.html |

---

## Test Credentials

### Admin Account (for Professor)
| Field | Value |
|---|---|
| **Email** | jcesperanza@neu.edu.ph |
| **Password** | Jeremias@12345 |
| **Admin ID** | A003 |

> You can log in using either the **email** or the **Admin ID**.

---

## Library Operating Hours

| Day | Hours |
|---|---|
| **Monday – Friday** | 5:00 AM – 8:00 PM |
| **Saturday – Sunday** | 9:00 AM – 4:00 PM |

> Login is **restricted outside these hours**. The system automatically checks out all visitors at closing time.

---

## How to Use the System

---

### 1. Registering a New Account
**URL:** https://neu-library-visitors-log-system.vercel.app/register.html

1. Go to the **Register** page
2. **Step 1 — Select User Type:**
 - Choose between **Student**, **Faculty**, or **Employee**
3. **Step 2 — Personal Information:**
 - Enter your **First Name**, **Middle Initial** (optional), and **Surname**
 - Enter your **ID Number** in the correct format:
 - Student: `XX-XXXXX-XXX` (e.g. `24-00001-001`)
 - Faculty: `FX…` (e.g. `F0001`)
 - Employee: `EX…` (e.g. `E0001`)
 - Enter your **Institutional Email** (must be `@neu.edu.ph`)
4. **Step 3 — Department:**
 - **Students:** Select your **College** then your **Program**
 - **Faculty:** Select your **College/Department**
 - **Employee:** Select your **Administrative Office**
5. Click **Complete Registration**
6. A countdown will appear and you will be **redirected to the Login page** after 5 seconds

---

### 2. ️ Logging In to the Library (Check-In)
**URL:** https://neu-library-visitors-log-system.vercel.app/

1. Go to the **Visitor Login** page
2. Enter your **Student/Faculty/Employee ID** or your **@neu.edu.ph email**
3. Click **Look Up**
4. Your name and department will appear on the left side and right side of the screen
5. Select your **Purpose of Visit:**
 - Study, Research, Borrow/Return Books, PC/Internet Usage, Meeting, Duty/Work, Official Business, Others
 - If you select **Others**, a text field will appear — describe your purpose
6. Click ** Log In to Library**
7. A success message will appear with your **check-in time**
8. The welcome panel on the left will show your name and details, then **fade away after 5 seconds**

---

### 3. Logging Out of the Library (Check-Out)
**URL:** https://neu-library-visitors-log-system.vercel.app/

1. Go to the **Visitor Login** page
2. Enter your **ID or email** and click **Look Up**
3. The system detects you are **already checked in** and shows:
 - ️ *"Already Checked In — You're currently inside. Log out now?"*
4. Click ** Log Out Now**
5. Your **check-out time** is recorded and your visit is marked as **OUT**
6. The left panel shows *"Logged out at [time]"* and fades away after 5 seconds

> **Note:** If you forget to log out, the system will **automatically check you out at closing time**.

---

### 4. ️ Admin Login
**URL:** https://neu-library-visitors-log-system.vercel.app/admin-login.html

1. Go to the **Admin Portal** page
 - You can also access it by clicking the ** key icon** in the top-right corner of the header
2. Enter your **Admin ID** (e.g. `A002`) or your **@neu.edu.ph email**
3. Enter your **Password**
4. Click ** Sign In to Dashboard**
5. You will be redirected to the **Admin Dashboard**

---

### 5. Admin Dashboard
**URL:** https://neu-library-visitors-log-system.vercel.app/admin-dashboard.html

The dashboard is **fully real-time** — it updates instantly when visitors check in or out.

#### Statistics Cards
At the top of the dashboard, you can see:
- **Currently Inside** — number of people currently in the library
- **Students Inside** — students currently inside
- **Faculty Inside** — faculty currently inside
- **Employees Inside** — employees currently inside
- **Avg Dwell Time** — average time visitors spend in the library today
- **Peak Hour Today** — the busiest hour of the day

#### Purpose Breakdown
A bar chart showing how many visitors came for each purpose today (Study, Research, etc.)

#### Top 5 Active Students & Colleges
Rankings of the most frequent student visitors and most active colleges — all-time records.
- Click ** PDF** to download the rankings as a professional PDF report

#### Peak Hours Chart
A bar chart showing visitor traffic by hour from 7 AM to 8 PM.

#### Sync Button
Click ** Sync** next to the welcome message to manually refresh all dashboard data.

---

### 6. Visitor Logs Tab
Inside the dashboard under **Records Management → Visitor Logs**:

- **Search** by ID, Name, or Email
- **Filter** by Purpose, Department, Status (IN/OUT), and Date Range
- **Export** the filtered results as:
 - **CSV** — for spreadsheet use
 - **Excel** — styled spreadsheet with headers and filters info
 - **PDF** — professional landscape report with NEU Library header

---

### 7. User Management Tab
Inside the dashboard under **Records Management → User Management**:

- View all registered users (Students, Faculty, Employees)
- **Filter** by Type, Department, Program, Status, and Registration Date Range
- **Block** or **Activate** user accounts
- **Delete** users (also removes their visit history)
- **Export** as CSV, Excel, or PDF

---

### 8. ️ Admin Management Tab
Inside the dashboard under **Records Management → Admin Management**:

- View all admin accounts
- **Create new admins** — use format `A001`, `A002`, etc. for Admin ID
- **Change passwords** for any admin account
- **Delete** admin accounts (cannot delete your own account)

---

## ️ Technical Stack

| Technology | Purpose |
|---|---|
| **HTML5 / CSS3 / JavaScript (ES6)** | Frontend |
| **Supabase** | Backend database & real-time updates |
| **Vercel** | Hosting & deployment |
| **jsPDF + AutoTable** | PDF generation |
| **Montserrat (Google Fonts)** | Typography |

---

## ️ Database Tables

| Table | Description |
|---|---|
| `profiles` | All registered users (Students, Faculty, Employees) |
| `visitor_logs` | Every check-in and check-out record |
| `admins` | Admin accounts (separate from regular users) |

---

## ‍ Developer

**Thyrone Asuncion**
College of Informatics and Computing Studies
New Era University
