<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Appointments | Sunrise Dental Clinic</title>

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

        /* ================= NAVBAR ================= */

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
            font-size: 24px;
            font-weight: bold;
        }

        .user-area {
            display: flex;
            align-items: center;
            gap: 15px;
            font-size: 14px;
        }

        .role {
            background: rgba(255,255,255,0.18);
            padding: 7px 13px;
            border-radius: 20px;
        }

        .dashboard-btn {
            text-decoration: none;
            color: white;
            border: 1px solid rgba(255,255,255,0.6);
            padding: 10px 18px;
            border-radius: 8px;
        }

        .dashboard-btn:hover {
            background: white;
            color: #0789a8;
        }

        /* ================= MAIN ================= */

        .main {
            max-width: 1100px;
            margin: 0 auto;
            padding: 40px 25px;
        }

        .page-title {
            margin-bottom: 25px;
        }

        .page-title h1 {
            font-size: 32px;
            color: #123b4a;
            margin-bottom: 8px;
        }

        .page-title p {
            color: #71828c;
            font-size: 16px;
        }

        /* ================= CARD ================= */

        .card {
            background: white;
            border-radius: 16px;
            padding: 35px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
            margin-bottom: 30px;
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .card-header h2 {
            color: #123b4a;
            font-size: 24px;
        }

        .required {
            color: #0789a8;
            font-size: 13px;
        }

        /* ================= FORM ================= */

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 22px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .full-width {
            grid-column: 1 / -1;
        }

        label {
            font-weight: bold;
            margin-bottom: 8px;
            color: #183b4c;
        }

        input,
        select,
        textarea {
            width: 100%;
            padding: 14px;
            border: 1px solid #d5e1e7;
            border-radius: 9px;
            font-size: 15px;
            outline: none;
            background: white;
        }

        input:focus,
        select:focus,
        textarea:focus {
            border-color: #0789a8;
            box-shadow: 0 0 0 3px rgba(7,137,168,0.10);
        }

        input[readonly] {
            background: #f4f8fb;
            color: #526b76;
        }

        textarea {
            resize: vertical;
            min-height: 100px;
        }

        .hint {
            font-size: 13px;
            color: #71828c;
            margin-top: 7px;
        }

        /* ================= PATIENT STATUS ================= */

        .patient-status {
            margin-top: 8px;
            font-size: 13px;
            min-height: 18px;
        }

        .loading {
            color: #0789a8;
        }

        .success {
            color: #16834a;
            font-weight: bold;
        }

        .error {
            color: #dc3545;
            font-weight: bold;
        }

        /* ================= BUTTONS ================= */

        .button-row {
            margin-top: 25px;
            display: flex;
            gap: 12px;
        }

        .btn {
            border: none;
            padding: 14px 24px;
            border-radius: 9px;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
        }

        .btn-primary {
            background: #0789a8;
            color: white;
        }

        .btn-primary:hover {
            background: #06758f;
        }

        .btn-secondary {
            background: #eef3f5;
            color: #183b4c;
        }

        .btn-secondary:hover {
            background: #dde7eb;
        }

        /* ================= TABLE ================= */

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #0789a8;
            color: white;
            padding: 14px;
            text-align: left;
        }

        td {
            padding: 13px;
            border-bottom: 1px solid #e5ecef;
        }

        tr:hover {
            background: #f7fbfc;
        }

        .status {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        .scheduled {
            background: #e6f7fb;
            color: #0789a8;
        }

        .completed {
            background: #e8f7ee;
            color: #16834a;
        }

        .cancelled {
            background: #fdecec;
            color: #dc3545;
        }

        .delete-btn {
            color: #dc3545;
            text-decoration: none;
            font-weight: bold;
        }

        .delete-btn:hover {
            text-decoration: underline;
        }

        /* ================= RESPONSIVE ================= */

        @media (max-width: 750px) {

            .navbar {
                padding: 0 20px;
            }

            .logo {
                font-size: 19px;
            }

            .user-area {
                display: none;
            }

            .main {
                padding: 25px 15px;
            }

            .card {
                padding: 22px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .full-width {
                grid-column: auto;
            }

        }

    </style>

</head>

<body>

<!-- ================= NAVBAR ================= -->

<div class="navbar">

    <div class="logo">
        🦷 Sunrise Dental Clinic
    </div>

    <div class="user-area">

        <span>
            Welcome, <%= username %>
        </span>

        <% if (role != null) { %>
            <span class="role">
                <%= role %>
            </span>
        <% } %>

        <a href="dashboard.jsp" class="dashboard-btn">
            ← Dashboard
        </a>

    </div>

</div>


<!-- ================= MAIN ================= -->

<div class="main">

    <div class="page-title">

        <h1>Appointment Management</h1>

        <p>
            Schedule and manage patient appointments.
        </p>

    </div>


    <!-- ================= APPOINTMENT FORM ================= -->

    <div class="card">

        <div class="card-header">

            <h2>
                📅 Schedule New Appointment
            </h2>

            <span class="required">
                * Required fields
            </span>

        </div>
        
        <%
    String errorCode = request.getParameter("error");
    String successCode = request.getParameter("success");

    String errorMessage = null;

    if (errorCode != null) {
        switch (errorCode) {
            case "pastdate":
                errorMessage = "Appointment date cannot be in the past. Please choose today or a future date.";
                break;
            case "slotunavailable":
                errorMessage = "This dentist already has an appointment at the selected date and time. Please choose a different slot.";
                break;
            case "patientnotfound":
                errorMessage = "No patient exists with the given Patient ID. Please check and try again.";
                break;
            case "patient":
                errorMessage = "Patient ID is required and must be valid.";
                break;
            case "date":
                errorMessage = "Please enter a valid appointment date.";
                break;
            case "time":
                errorMessage = "Please enter a valid appointment time.";
                break;
            case "dentist":
                errorMessage = "Dentist name is required.";
                break;
            case "database":
                errorMessage = "A database error occurred. Please try again.";
                break;
            default:
                errorMessage = "An error occurred. Please check your input and try again.";
        }
    }
%>

<!-- ================= ERROR / SUCCESS BANNER ================= -->

<% if (errorMessage != null) { %>
    <div style="background:#fdecea; color:#dc3545; border:1px solid #f5c2c7;
                padding:14px 20px; border-radius:8px; margin-bottom:20px; font-weight:bold;">
        ⚠ <%= errorMessage %>
    </div>
<% } %>

<% if ("1".equals(successCode)) { %>
    <div style="background:#e7f7ec; color:#16834a; border:1px solid #b7e4c7;
                padding:14px 20px; border-radius:8px; margin-bottom:20px; font-weight:bold;">
        ✔ Appointment booked successfully!
    </div>
<% } %>

<!-- ================= APPOINTMENT FORM (existing code below) ================= -->


        <form action="appointments"
              method="post"
              id="appointmentForm">


            <div class="form-grid">


                <!-- PATIENT ID -->

                <div class="form-group">

                    <label for="patient_id">
                        Patient ID *
                    </label>

                    <input
                        type="number"
                        id="patient_id"
                        name="patient_id"
                        min="1"
                        placeholder="Enter Patient ID"
                        required
                        autocomplete="off">

                    <div class="hint">
                        Enter Patient ID to load patient details automatically.
                    </div>

                    <div id="patientStatus"
                         class="patient-status">
                    </div>

                </div>


                <!-- PATIENT NAME -->

                <div class="form-group">

                    <label for="patient_name">
                        Patient Name *
                    </label>

                    <input
                        type="text"
                        id="patient_name"
                        name="patient_name"
                        placeholder="Patient name"
                        readonly
                        required>

                </div>


                <!-- PHONE -->

                <div class="form-group">

                    <label for="phone">
                        Phone
                    </label>

                    <input
                        type="text"
                        id="phone"
                        name="phone"
                        placeholder="Patient phone"
                        readonly>

                </div>


                <!-- EMAIL -->

                <div class="form-group">

                    <label for="email">
                        Email
                    </label>

                    <input
                        type="email"
                        id="email"
                        name="email"
                        placeholder="Patient email"
                        readonly>

                </div>


                <!-- APPOINTMENT DATE -->

                <div class="form-group">

                    <label for="appointment_date">
                        Appointment Date *
                    </label>

                    <input
                        type="date"
                        id="appointment_date"
                        name="appointment_date"
                        required>

                </div>


                <!-- APPOINTMENT TIME -->

                <div class="form-group">

                    <label for="appointment_time">
                        Appointment Time *
                    </label>

                    <input
                        type="time"
                        id="appointment_time"
                        name="appointment_time"
                        required>

                </div>


                <!-- DENTIST -->

                <div class="form-group">

                    <label for="dentist">
                        Dentist *
                    </label>

                    <input
                        type="text"
                        id="dentist"
                        name="dentist"
                        placeholder="Enter dentist name"
                        required>

                </div>


                <!-- STATUS -->

                <div class="form-group">

                    <label for="status">
                        Appointment Status *
                    </label>

                    <select
                        id="status"
                        name="status"
                        required>

                        <option value="Scheduled">
                            Scheduled
                        </option>

                        <option value="Completed">
                            Completed
                        </option>

                        <option value="Cancelled">
                            Cancelled
                        </option>

                    </select>

                </div>


                <!-- NOTES -->

                <div class="form-group full-width">

                    <label for="notes">
                        Appointment Notes
                    </label>

                    <textarea
                        id="notes"
                        name="notes"
                        placeholder="Enter any additional notes about the appointment..."></textarea>

                </div>

            </div>


            <!-- BUTTONS -->

            <div class="button-row">

                <button
                    type="submit"
                    class="btn btn-primary">
                    📅 Schedule Appointment
                </button>

                <button
                    type="reset"
                    class="btn btn-secondary"
                    id="clearBtn">
                    Clear Form
                </button>

            </div>

        </form>

    </div>


    <!-- ================= APPOINTMENT LIST ================= -->

    <div class="card">

        <div class="card-header">

            <h2>
                📋 Appointment List
            </h2>

        </div>


        <div class="table-container">

            <table>

                <thead>

                    <tr>

                        <th>ID</th>

                        <th>Patient</th>

                        <th>Date</th>

                        <th>Time</th>

                        <th>Dentist</th>

                        <th>Status</th>

                        <th>Action</th>

                    </tr>

                </thead>

                <tbody>

                <%
                    Object appointmentData =
                        request.getAttribute("appointments");

                    if (appointmentData instanceof java.sql.ResultSet) {

                        java.sql.ResultSet appointments =
                            (java.sql.ResultSet) appointmentData;

                        while (appointments.next()) {
                %>

                    <tr>

                        <td>
                            <%= appointments.getInt("appointment_id") %>
                        </td>

                        <td>
                            <%= appointments.getString("patient_name") %>
                        </td>

                        <td>
                            <%= appointments.getDate("appointment_date") %>
                        </td>

                        <td>
                            <%= appointments.getTime("appointment_time") %>
                        </td>

                        <td>
                            <%= appointments.getString("dentist") %>
                        </td>

                        <td>

                            <%
                                String appointmentStatus =
                                    appointments.getString("status");

                                String statusClass =
                                    "scheduled";

                                if ("Completed".equalsIgnoreCase(appointmentStatus)) {
                                    statusClass = "completed";
                                }
                                else if ("Cancelled".equalsIgnoreCase(appointmentStatus)) {
                                    statusClass = "cancelled";
                                }
                            %>

                            <span class="status <%= statusClass %>">
                                <%= appointmentStatus %>
                            </span>

                        </td>

                        <td>

                            <a
                                href="appointments?action=delete&id=<%= appointments.getInt("appointment_id") %>"
                                class="delete-btn"
                                onclick="return confirm('Are you sure you want to delete this appointment?');">

                                Delete

                            </a>

                        </td>

                    </tr>

                <%
                        }

                        appointments.close();

                    } else {
                %>

                    <tr>

                        <td colspan="7"
                            style="text-align:center; padding:30px; color:#71828c;">

                            No appointments found.

                        </td>

                    </tr>

                <%
                    }
                %>

                </tbody>

            </table>

        </div>

    </div>

</div>


<!-- ================= JAVASCRIPT ================= -->

<script>

    const patientIdInput =
        document.getElementById("patient_id");

    const patientNameInput =
        document.getElementById("patient_name");

    const phoneInput =
        document.getElementById("phone");

    const emailInput =
        document.getElementById("email");

    const patientStatus =
        document.getElementById("patientStatus");


    let searchTimer = null;


    /* ==========================================
       LOAD PATIENT DETAILS
       ========================================== */

    function loadPatient() {

        const patientId =
            patientIdInput.value.trim();


        // Empty ID

        if (patientId === "") {

            clearPatientFields();

            patientStatus.textContent = "";

            return;
        }


        // Invalid ID

        if (!/^[0-9]+$/.test(patientId)) {

            clearPatientFields();

            patientStatus.textContent =
                "Please enter a valid Patient ID.";

            patientStatus.className =
                "patient-status error";

            return;
        }


        patientStatus.textContent =
            "Loading patient information...";

        patientStatus.className =
            "patient-status loading";


        /*
         * IMPORTANT:
         * PatientServlet must support:
         *
         * /patients?action=get&id=1
         *
         */

        const url =
            "<%= request.getContextPath() %>/patients?action=get&id="
            + encodeURIComponent(patientId);


        fetch(url, {
            method: "GET",
            headers: {
                "Accept": "application/json"
            },
            cache: "no-cache"
        })

        .then(function(response) {

            if (!response.ok) {

                throw new Error(
                    "Server returned HTTP " +
                    response.status
                );

            }

            return response.text();

        })

        .then(function(text) {

            /*
             * We use text() first instead of response.json().
             * This prevents:
             *
             * Unexpected token '<'
             *
             * from crashing the page.
             */

            let data;

            try {

                data = JSON.parse(text);

            } catch (error) {

                console.error(
                    "Server response was not JSON:",
                    text
                );

                throw new Error(
                    "PatientServlet did not return JSON."
                );

            }


            if (data.success === true &&
                data.patient != null) {


                const patient =
                    data.patient;


                patientNameInput.value =
                    patient.patient_name || "";

                phoneInput.value =
                    patient.phone || "";

                emailInput.value =
                    patient.email || "";


                patientStatus.textContent =
                    "✓ Patient information loaded successfully.";

                patientStatus.className =
                    "patient-status success";


            } else {


                clearPatientFields();


                patientStatus.textContent =
                    data.message ||
                    "Patient not found.";

                patientStatus.className =
                    "patient-status error";

            }

        })

        .catch(function(error) {

            console.error(
                "Patient loading error:",
                error
            );


            clearPatientFields();


            patientStatus.textContent =
                "✕ Unable to load patient information.";

            patientStatus.className =
                "patient-status error";

        });

    }


    /* ==========================================
       CLEAR PATIENT FIELDS
       ========================================== */

    function clearPatientFields() {

        patientNameInput.value = "";
        phoneInput.value = "";
        emailInput.value = "";

    }


    /* ==========================================
       SEARCH WHEN USER STOPS TYPING
       ========================================== */

    patientIdInput.addEventListener(
        "input",
        function() {

            clearTimeout(searchTimer);

            searchTimer =
                setTimeout(
                    loadPatient,
                    400
                );

        }
    );


    /* ==========================================
       SEARCH WHEN ENTER IS PRESSED
       ========================================== */

    patientIdInput.addEventListener(
        "keydown",
        function(event) {

            if (event.key === "Enter") {

                event.preventDefault();

                clearTimeout(searchTimer);

                loadPatient();

            }

        }
    );


    /* ==========================================
       CLEAR FORM
       ========================================== */

    document.getElementById("clearBtn")
        .addEventListener(
            "click",
            function() {

                clearPatientFields();

                patientStatus.textContent = "";

            }
        );


    /* ==========================================
       FORM VALIDATION
       ========================================== */

    document.getElementById("appointmentForm")
        .addEventListener(
            "submit",
            function(event) {

                if (
                    patientIdInput.value.trim() === "" ||
                    patientNameInput.value.trim() === ""
                ) {

                    event.preventDefault();

                    alert(
                        "Please enter a valid Patient ID and load the patient information before scheduling the appointment."
                    );

                    patientIdInput.focus();

                    return;
                }

            }
        );

</script>


</body>

</html>