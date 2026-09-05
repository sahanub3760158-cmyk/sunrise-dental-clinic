<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    Integer totalPatients =
        (Integer) request.getAttribute("totalPatients");

    Integer totalAppointments =
        (Integer) request.getAttribute("totalAppointments");

    Integer totalBills =
        (Integer) request.getAttribute("totalBills");

    Double totalRevenue =
        (Double) request.getAttribute("totalRevenue");

    Integer pendingPayments =
        (Integer) request.getAttribute("pendingPayments");

    Integer completedAppointments =
        (Integer) request.getAttribute("completedAppointments");

    if (totalPatients == null) totalPatients = 0;
    if (totalAppointments == null) totalAppointments = 0;
    if (totalBills == null) totalBills = 0;
    if (totalRevenue == null) totalRevenue = 0.0;
    if (pendingPayments == null) pendingPayments = 0;
    if (completedAppointments == null) completedAppointments = 0;
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Reports | Sunrise Dental Clinic</title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, Helvetica, sans-serif;
        }

        body {
            background: #f4f8fb;
            color: #183b4c;
        }

        /* =========================
           HEADER
           ========================= */

        .navbar {
            height: 70px;
            background: #0789a8;
            color: white;

            display: flex;
            align-items: center;
            justify-content: space-between;

            padding: 0 40px;

            box-shadow: 0 3px 12px rgba(0,0,0,0.10);
        }

        .logo {
            font-size: 23px;
            font-weight: bold;
        }

        .user-area {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .role {
            background: rgba(255,255,255,0.18);
            padding: 7px 14px;
            border-radius: 20px;
        }

        .dashboard-btn {
            color: white;
            text-decoration: none;

            border: 1px solid rgba(255,255,255,0.6);

            padding: 10px 18px;

            border-radius: 8px;

            transition: 0.2s;
        }

        .dashboard-btn:hover {
            background: white;
            color: #0789a8;
        }

        /* =========================
           MAIN
           ========================= */

        .main {
            padding: 40px;
            max-width: 1400px;
            margin: auto;
        }

        .page-header {
            margin-bottom: 30px;
        }

        .page-header h1 {
            font-size: 34px;
            color: #123b4a;
            margin-bottom: 8px;
        }

        .page-header p {
            color: #71828c;
            font-size: 16px;
        }

        /* =========================
           STAT CARDS
           ========================= */

        .stats {
            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 22px;

            margin-bottom: 30px;
        }

        .stat-card {
            background: white;

            border-radius: 15px;

            padding: 25px;

            box-shadow:
                0 5px 20px rgba(0,0,0,0.06);

            display: flex;

            align-items: center;

            gap: 20px;

            transition: 0.2s;
        }

        .stat-card:hover {
            transform: translateY(-3px);

            box-shadow:
                0 8px 25px rgba(0,0,0,0.10);
        }

        .icon {
            width: 60px;
            height: 60px;

            display: flex;

            align-items: center;
            justify-content: center;

            border-radius: 12px;

            background: #eaf8fc;

            font-size: 30px;
        }

        .stat-info h3 {
            font-size: 14px;

            color: #71828c;

            margin-bottom: 7px;

            font-weight: normal;
        }

        .stat-info strong {
            font-size: 28px;

            color: #0789a8;
        }

        /* =========================
           REPORT SECTION
           ========================= */

        .report-section {
            background: white;

            border-radius: 15px;

            padding: 30px;

            box-shadow:
                0 5px 20px rgba(0,0,0,0.06);

            margin-bottom: 30px;
        }

        .report-section h2 {
            color: #123b4a;

            font-size: 22px;

            margin-bottom: 22px;
        }

        .report-grid {
            display: grid;

            grid-template-columns:
                1fr 1fr;

            gap: 20px;
        }

        .report-item {
            border: 1px solid #e0e8ed;

            border-radius: 10px;

            padding: 20px;

            display: flex;

            justify-content: space-between;

            align-items: center;
        }

        .report-item span {
            color: #71828c;
        }

        .report-item strong {
            color: #0789a8;

            font-size: 20px;
        }

        /* =========================
           REVENUE
           ========================= */

        .revenue-box {
            background: #eaf8fc;

            border-radius: 12px;

            padding: 25px;

            text-align: center;
        }

        .revenue-box h3 {
            color: #71828c;

            font-size: 15px;

            margin-bottom: 10px;
        }

        .revenue {
            color: #0789a8;

            font-size: 34px;

            font-weight: bold;
        }

        /* =========================
           FOOTER
           ========================= */

        .footer {
            text-align: center;

            color: #8a9aa3;

            padding: 20px;

            font-size: 13px;
        }

        /* =========================
           RESPONSIVE
           ========================= */

        @media (max-width: 900px) {

            .stats {
                grid-template-columns: 1fr 1fr;
            }

            .report-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 600px) {

            .navbar {
                padding: 0 20px;
            }

            .user-area {
                display: none;
            }

            .main {
                padding: 20px;
            }

            .stats {
                grid-template-columns: 1fr;
            }

            .page-header h1 {
                font-size: 28px;
            }
        }

    </style>

</head>

<body>

<!-- =========================
     NAVBAR
     ========================= -->

<div class="navbar">

    <div class="logo">
        🦷 Sunrise Dental Clinic
    </div>

    <div class="user-area">

        <span>
            Welcome, <%= username %>
        </span>

        <span class="role">
            <%= role %>
        </span>

        <a href="dashboard.jsp"
           class="dashboard-btn">
            ← Dashboard
        </a>

    </div>

</div>


<!-- =========================
     MAIN CONTENT
     ========================= -->

<div class="main">

    <div class="page-header">

        <h1>
            Reports & Analytics
        </h1>

        <p>
            Overview of Sunrise Dental Clinic
            patients, appointments and billing.
        </p>

    </div>


    <!-- =========================
         STATISTICS
         ========================= -->

    <div class="stats">

        <div class="stat-card">

            <div class="icon">
                👥
            </div>

            <div class="stat-info">

                <h3>
                    Total Patients
                </h3>

                <strong>
                    <%= totalPatients %>
                </strong>

            </div>

        </div>


        <div class="stat-card">

            <div class="icon">
                📅
            </div>

            <div class="stat-info">

                <h3>
                    Total Appointments
                </h3>

                <strong>
                    <%= totalAppointments %>
                </strong>

            </div>

        </div>


        <div class="stat-card">

            <div class="icon">
                💳
            </div>

            <div class="stat-info">

                <h3>
                    Total Bills
                </h3>

                <strong>
                    <%= totalBills %>
                </strong>

            </div>

        </div>


        <div class="stat-card">

            <div class="icon">
                ✅
            </div>

            <div class="stat-info">

                <h3>
                    Completed Appointments
                </h3>

                <strong>
                    <%= completedAppointments %>
                </strong>

            </div>

        </div>


        <div class="stat-card">

            <div class="icon">
                ⏳
            </div>

            <div class="stat-info">

                <h3>
                    Pending Payments
                </h3>

                <strong>
                    <%= pendingPayments %>
                </strong>

            </div>

        </div>


        <div class="stat-card">

            <div class="icon">
                💰
            </div>

            <div class="stat-info">

                <h3>
                    Paid Revenue
                </h3>

                <strong>
                    LKR <%= String.format("%.2f", totalRevenue) %>
                </strong>

            </div>

        </div>

    </div>


    <!-- =========================
         APPOINTMENT REPORT
         ========================= -->

    <div class="report-section">

        <h2>
            📅 Appointment Summary
        </h2>

        <div class="report-grid">

            <div class="report-item">

                <span>
                    Total Appointments
                </span>

                <strong>
                    <%= totalAppointments %>
                </strong>

            </div>

            <div class="report-item">

                <span>
                    Completed Appointments
                </span>

                <strong>
                    <%= completedAppointments %>
                </strong>

            </div>

        </div>

    </div>


    <!-- =========================
         BILLING REPORT
         ========================= -->

    <div class="report-section">

        <h2>
            💳 Billing Summary
        </h2>

        <div class="report-grid">

            <div class="report-item">

                <span>
                    Total Bills
                </span>

                <strong>
                    <%= totalBills %>
                </strong>

            </div>

            <div class="report-item">

                <span>
                    Pending Payments
                </span>

                <strong>
                    <%= pendingPayments %>
                </strong>

            </div>

        </div>

        <br>

        <div class="revenue-box">

            <h3>
                Total Paid Revenue
            </h3>

            <div class="revenue">
                LKR <%= String.format("%.2f", totalRevenue) %>
            </div>

        </div>

    </div>


    <!-- =========================
         PATIENT REPORT
         ========================= -->

    <div class="report-section">

        <h2>
            👥 Patient Summary
        </h2>

        <div class="report-item">

            <span>
                Registered Patients
            </span>

            <strong>
                <%= totalPatients %>
            </strong>

        </div>

    </div>

</div>


<div class="footer">

    Sunrise Dental Clinic
    © 2026 | Appointment & Patient Management System

</div>

</body>

</html>