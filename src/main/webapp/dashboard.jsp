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

    if (role == null) {
        role = "Staff";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Sunrise Dental Clinic | Dashboard
    </title>

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


        /* =====================================================
           NAVBAR
        ===================================================== */

        .navbar {

            height: 72px;

            background: #0789a8;

            color: white;

            display: flex;

            align-items: center;

            justify-content: space-between;

            padding: 0 32px;

            position: fixed;

            top: 0;
            left: 0;
            right: 0;

            z-index: 1000;

            box-shadow:
                0 3px 15px rgba(0,0,0,0.12);
        }


        .logo {

            display: flex;

            align-items: center;

            gap: 12px;

            font-size: 22px;

            font-weight: bold;
        }


        .logo-icon {

            width: 42px;
            height: 42px;

            border-radius: 11px;

            background:
                rgba(255,255,255,0.18);

            display: flex;

            align-items: center;
            justify-content: center;

            font-size: 25px;
        }


        .user-area {

            display: flex;

            align-items: center;

            gap: 15px;

            font-size: 14px;
        }


        .user-details {

            text-align: right;
        }


        .user-name {

            font-weight: bold;

            margin-bottom: 3px;
        }


        .user-role {

            font-size: 12px;

            opacity: 0.85;
        }


        .profile-icon {

            width: 42px;
            height: 42px;

            border-radius: 50%;

            background: white;

            color: #0789a8;

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 20px;

            font-weight: bold;
        }


        .logout-btn {

            text-decoration: none;

            color: white;

            border: 1px solid
                rgba(255,255,255,0.65);

            padding: 9px 15px;

            border-radius: 8px;

            font-size: 13px;

            transition: 0.2s;
        }


        .logout-btn:hover {

            background: white;

            color: #0789a8;
        }


        /* =====================================================
           SIDEBAR
        ===================================================== */

        .sidebar {

            position: fixed;

            top: 72px;
            left: 0;

            width: 240px;

            height: calc(100vh - 72px);

            background: white;

            border-right:
                1px solid #e1e9ed;

            padding: 25px 15px;

            z-index: 900;
        }


        .menu-title {

            color: #8a9aa3;

            font-size: 11px;

            font-weight: bold;

            letter-spacing: 1px;

            padding: 0 15px 12px;

            text-transform: uppercase;
        }


        .menu-item {

            display: flex;

            align-items: center;

            gap: 13px;

            padding: 13px 15px;

            margin-bottom: 6px;

            border-radius: 9px;

            color: #4c6572;

            text-decoration: none;

            font-size: 14px;

            transition: 0.2s;
        }


        .menu-item:hover {

            background: #eaf8fc;

            color: #0789a8;
        }


        .menu-item.active {

            background: #e4f6fa;

            color: #0789a8;

            font-weight: bold;
        }


        .menu-icon {

            width: 25px;

            text-align: center;

            font-size: 18px;
        }


        /* =====================================================
           MAIN
        ===================================================== */

        .main {

            margin-left: 240px;

            padding: 105px 40px 40px;

            min-height: 100vh;
        }


        /* =====================================================
           PAGE HEADER
        ===================================================== */

        .page-header {

            display: flex;

            justify-content: space-between;

            align-items: center;

            margin-bottom: 28px;
        }


        .page-header h1 {

            color: #123b4a;

            font-size: 30px;

            margin-bottom: 7px;
        }


        .page-header p {

            color: #71828c;

            font-size: 14px;
        }


        .date-box {

            background: white;

            padding: 12px 17px;

            border-radius: 9px;

            border:
                1px solid #e1e9ed;

            color: #5d717d;

            font-size: 13px;
        }


        /* =====================================================
           STAT CARDS
        ===================================================== */

        .stats-grid {

            display: grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap: 20px;

            margin-bottom: 28px;
        }


        .stat-card {

            background: white;

            border-radius: 14px;

            padding: 23px;

            box-shadow:
                0 5px 20px rgba(0,0,0,0.055);

            display: flex;

            align-items: center;

            gap: 17px;

            transition: 0.2s;
        }


        .stat-card:hover {

            transform: translateY(-3px);

            box-shadow:
                0 8px 25px rgba(0,0,0,0.09);
        }


        .stat-icon {

            width: 55px;
            height: 55px;

            border-radius: 12px;

            background: #eaf8fc;

            display: flex;

            align-items: center;
            justify-content: center;

            font-size: 27px;
        }


        .stat-info h3 {

            color: #71828c;

            font-size: 12px;

            font-weight: normal;

            margin-bottom: 7px;
        }


        .stat-number {

            color: #123b4a;

            font-size: 25px;

            font-weight: bold;
        }


        /* =====================================================
           CONTENT GRID
        ===================================================== */

        .content-grid {

            display: grid;

            grid-template-columns:
                2fr 1fr;

            gap: 22px;

            margin-bottom: 25px;
        }


        .panel {

            background: white;

            border-radius: 14px;

            padding: 27px;

            box-shadow:
                0 5px 20px rgba(0,0,0,0.055);
        }


        .panel-header {

            display: flex;

            justify-content: space-between;

            align-items: center;

            margin-bottom: 22px;
        }


        .panel-header h2 {

            color: #123b4a;

            font-size: 20px;
        }


        .view-link {

            color: #0789a8;

            text-decoration: none;

            font-size: 13px;

            font-weight: bold;
        }


        .view-link:hover {

            text-decoration: underline;
        }


        /* =====================================================
           MANAGEMENT CARDS
        ===================================================== */

        .management-grid {

            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 15px;
        }


        .management-card {

            border:
                1px solid #e2eaee;

            border-radius: 11px;

            padding: 20px;

            text-decoration: none;

            transition: 0.2s;
        }


        .management-card:hover {

            border-color: #0789a8;

            background: #f7fcfd;

            transform: translateY(-2px);
        }


        .management-icon {

            font-size: 27px;

            margin-bottom: 13px;
        }


        .management-card h3 {

            color: #183b4c;

            font-size: 15px;

            margin-bottom: 7px;
        }


        .management-card p {

            color: #71828c;

            font-size: 12px;

            line-height: 1.5;
        }


        /* =====================================================
           QUICK ACTIONS
        ===================================================== */

        .quick-actions {

            display: flex;

            flex-direction: column;

            gap: 12px;
        }


        .quick-btn {

            display: flex;

            align-items: center;

            gap: 12px;

            text-decoration: none;

            padding: 13px 15px;

            border-radius: 9px;

            border:
                1px solid #e1e9ed;

            color: #405b68;

            font-size: 13px;

            transition: 0.2s;
        }


        .quick-btn:hover {

            background: #eaf8fc;

            border-color: #0789a8;

            color: #0789a8;
        }


        .quick-icon {

            font-size: 18px;

            width: 25px;

            text-align: center;
        }


        /* =====================================================
           INFO PANEL
        ===================================================== */

        .info-grid {

            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 18px;
        }


        .info-box {

            background: #f7fafb;

            border-radius: 10px;

            padding: 18px;

            border:
                1px solid #e6edf0;
        }


        .info-box h4 {

            color: #71828c;

            font-size: 12px;

            font-weight: normal;

            margin-bottom: 8px;
        }


        .info-box strong {

            color: #0789a8;

            font-size: 18px;
        }


        /* =====================================================
           FOOTER
        ===================================================== */

        .footer {

            text-align: center;

            color: #9aa8af;

            font-size: 12px;

            padding: 20px 0 5px;
        }


        /* =====================================================
           RESPONSIVE
        ===================================================== */

        @media (max-width: 1100px) {

            .stats-grid {

                grid-template-columns:
                    repeat(2, 1fr);
            }

            .content-grid {

                grid-template-columns: 1fr;
            }

        }


        @media (max-width: 800px) {

            .sidebar {

                width: 70px;

                padding: 20px 8px;
            }


            .menu-title {

                display: none;
            }


            .menu-item {

                justify-content: center;

                padding: 14px 5px;
            }


            .menu-item span:not(.menu-icon) {

                display: none;
            }


            .main {

                margin-left: 70px;

                padding: 100px 20px 30px;
            }


            .logo-text {

                display: none;
            }


            .management-grid {

                grid-template-columns: 1fr;
            }


            .info-grid {

                grid-template-columns: 1fr;
            }

        }


        @media (max-width: 600px) {

            .navbar {

                padding: 0 15px;
            }


            .user-details,
            .logout-btn {

                display: none;
            }


            .stats-grid {

                grid-template-columns: 1fr;
            }


            .page-header {

                align-items: flex-start;

                flex-direction: column;

                gap: 12px;
            }


            .main {

                padding: 95px 15px 25px;
            }

        }

    </style>

</head>


<body>


<!-- =====================================================
     NAVBAR
===================================================== -->

<div class="navbar">

    <div class="logo">

        <div class="logo-icon">
            🦷
        </div>

        <span class="logo-text">
            Sunrise Dental Clinic
        </span>

    </div>


    <div class="user-area">

        <div class="user-details">

            <div class="user-name">
                <%= username %>
            </div>

            <div class="user-role">
                <%= role %>
            </div>

        </div>


        <div class="profile-icon">
            👤
        </div>


        <a href="logout"
           class="logout-btn">

            Logout

        </a>

    </div>

</div>


<!-- =====================================================
     SIDEBAR
===================================================== -->

<div class="sidebar">

    <div class="menu-title">
        Main Menu
    </div>


    <a href="dashboard.jsp"
       class="menu-item active">

        <span class="menu-icon">
            🏠
        </span>

        <span>
            Dashboard
        </span>

    </a>


    <a href="patients"
       class="menu-item">

        <span class="menu-icon">
            👥
        </span>

        <span>
            Patients
        </span>

    </a>


    <a href="appointments"
       class="menu-item">

        <span class="menu-icon">
            📅
        </span>

        <span>
            Appointments
        </span>

    </a>


    <a href="billing"
       class="menu-item">

        <span class="menu-icon">
            💳
        </span>

        <span>
            Billing
        </span>

    </a>


    <a href="reports"
       class="menu-item">

        <span class="menu-icon">
            📊
        </span>

        <span>
            Reports
        </span>

    </a>


    <a href="help.jsp"
       class="menu-item">

        <span class="menu-icon">
            ❓
        </span>

        <span>
            Help
        </span>

    </a>

</div>


<!-- =====================================================
     MAIN CONTENT
===================================================== -->

<div class="main">


    <!-- PAGE HEADER -->

    <div class="page-header">

        <div>

            <h1>
                Dashboard
            </h1>

            <p>
                Welcome back, <strong><%= username %></strong>.
                Here's an overview of the clinic.
            </p>

        </div>


        <div class="date-box">

            📅
            <%= new java.text.SimpleDateFormat(
                "dd MMMM yyyy"
            ).format(new java.util.Date()) %>

        </div>

    </div>


    <!-- =================================================
         STATISTICS
    ================================================= -->

    <div class="stats-grid">


        <div class="stat-card">

            <div class="stat-icon">
                👥
            </div>

            <div class="stat-info">

                <h3>
                    Patient Management
                </h3>

                <div class="stat-number">
                    Active
                </div>

            </div>

        </div>


        <div class="stat-card">

            <div class="stat-icon">
                📅
            </div>

            <div class="stat-info">

                <h3>
                    Appointment Management
                </h3>

                <div class="stat-number">
                    Active
                </div>

            </div>

        </div>


        <div class="stat-card">

            <div class="stat-icon">
                💳
            </div>

            <div class="stat-info">

                <h3>
                    Billing Management
                </h3>

                <div class="stat-number">
                    Active
                </div>

            </div>

        </div>


        <div class="stat-card">

            <div class="stat-icon">
                📊
            </div>

            <div class="stat-info">

                <h3>
                    Reports
                </h3>

                <div class="stat-number">
                    Available
                </div>

            </div>

        </div>

    </div>


    <!-- =================================================
         MAIN CONTENT GRID
    ================================================= -->

    <div class="content-grid">


        <!-- MANAGEMENT -->

        <div class="panel">

            <div class="panel-header">

                <h2>
                    Clinic Management
                </h2>

                <span>
                    🏥
                </span>

            </div>


            <div class="management-grid">


                <a href="patients"
                   class="management-card">

                    <div class="management-icon">
                        👥
                    </div>

                    <h3>
                        Patients
                    </h3>

                    <p>
                        Add, view and manage
                        patient records.
                    </p>

                </a>


                <a href="appointments"
                   class="management-card">

                    <div class="management-icon">
                        📅
                    </div>

                    <h3>
                        Appointments
                    </h3>

                    <p>
                        Schedule and manage
                        patient appointments.
                    </p>

                </a>


                <a href="billing"
                   class="management-card">

                    <div class="management-icon">
                        💳
                    </div>

                    <h3>
                        Billing
                    </h3>

                    <p>
                        Create and manage
                        patient bills.
                    </p>

                </a>


            </div>

        </div>


        <!-- QUICK ACTIONS -->

        <div class="panel">

            <div class="panel-header">

                <h2>
                    Quick Actions
                </h2>

                <span>
                    ⚡
                </span>

            </div>


            <div class="quick-actions">


                <a href="patients"
                   class="quick-btn">

                    <span class="quick-icon">
                        👤
                    </span>

                    <span>
                        Manage Patients
                    </span>

                </a>


                <a href="appointments"
                   class="quick-btn">

                    <span class="quick-icon">
                        📅
                    </span>

                    <span>
                        Schedule Appointment
                    </span>

                </a>


                <a href="billing"
                   class="quick-btn">

                    <span class="quick-icon">
                        💳
                    </span>

                    <span>
                        Create New Bill
                    </span>

                </a>


                <a href="reports"
                   class="quick-btn">

                    <span class="quick-icon">
                        📊
                    </span>

                    <span>
                        View Reports
                    </span>

                </a>

            </div>

        </div>

    </div>


    <!-- =================================================
         SYSTEM OVERVIEW
    ================================================= -->

    <div class="panel">

        <div class="panel-header">

            <h2>
                System Overview
            </h2>

            <span>
                ℹ️
            </span>

        </div>


        <div class="info-grid">


            <div class="info-box">

                <h4>
                    Logged-in User
                </h4>

                <strong>
                    <%= username %>
                </strong>

            </div>


            <div class="info-box">

                <h4>
                    Access Role
                </h4>

                <strong>
                    <%= role %>
                </strong>

            </div>


            <div class="info-box">

                <h4>
                    System Status
                </h4>

                <strong>
                    ● Online
                </strong>

            </div>


        </div>

    </div>


    <!-- FOOTER -->

    <div class="footer">

        © 2026 Sunrise Dental Clinic
        · Appointment & Patient Management System

    </div>


</div>


</body>

</html>