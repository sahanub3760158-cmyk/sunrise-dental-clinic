<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Billing Management | Sunrise Dental Clinic</title>

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
            font-size: 14px;
        }

        .role {
            background: rgba(255,255,255,0.18);
            padding: 7px 13px;
            border-radius: 20px;
        }

        .dashboard-btn {
            color: white;
            text-decoration: none;
            border: 1px solid rgba(255,255,255,0.7);
            padding: 9px 16px;
            border-radius: 8px;
            transition: 0.2s;
        }

        .dashboard-btn:hover {
            background: white;
            color: #0789a8;
        }


        /* =====================================================
           MAIN
        ===================================================== */

        .main {
            width: 90%;
            max-width: 1200px;
            margin: 40px auto;
        }

        .page-header {
            margin-bottom: 25px;
        }

        .page-header h1 {
            color: #123b4a;
            font-size: 32px;
            margin-bottom: 8px;
        }

        .page-header p {
            color: #71828c;
            font-size: 15px;
        }


        /* =====================================================
           CARD
        ===================================================== */

        .card {
            background: white;
            border-radius: 16px;
            padding: 32px;

            box-shadow: 0 5px 25px rgba(0,0,0,0.07);

            margin-bottom: 30px;
        }

        .card-title {
            display: flex;
            justify-content: space-between;
            align-items: center;

            margin-bottom: 28px;
        }

        .card-title h2 {
            color: #0789a8;
            font-size: 22px;
        }

        .required-text {
            color: #71828c;
            font-size: 13px;
        }


        /* =====================================================
           FORM
        ===================================================== */

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 22px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .full {
            grid-column: 1 / 3;
        }

        label {
            color: #183b4c;
            font-weight: bold;
            font-size: 14px;
            margin-bottom: 8px;
        }

        input,
        select,
        textarea {
            width: 100%;

            padding: 13px 14px;

            border: 1px solid #d3dfe5;

            border-radius: 8px;

            font-size: 14px;

            outline: none;

            background: white;

            transition: 0.2s;
        }

        input:focus,
        select:focus,
        textarea:focus {
            border-color: #0789a8;

            box-shadow:
                0 0 0 3px rgba(7,137,168,0.10);
        }

        input[readonly] {
            background: #f2f6f8;
            cursor: not-allowed;
        }

        textarea {
            min-height: 100px;
            resize: vertical;
        }

        .hint {
            color: #82919a;
            font-size: 12px;
            margin-top: 6px;
        }


        /* =====================================================
           STATUS MESSAGE
        ===================================================== */

        .status-message {
            min-height: 18px;
            margin-top: 7px;
            font-size: 13px;
        }

        .loading {
            color: #0789a8;
        }

        .success-text {
            color: #16803c;
            font-weight: bold;
        }

        .error-text {
            color: #d93025;
            font-weight: bold;
        }


        /* =====================================================
           BUTTONS
        ===================================================== */

        .button-area {
            display: flex;
            gap: 12px;
            margin-top: 28px;
        }

        .btn {
            border: none;
            padding: 13px 23px;
            border-radius: 8px;

            font-size: 14px;
            font-weight: bold;

            cursor: pointer;

            transition: 0.2s;
        }

        .btn-primary {
            background: #0789a8;
            color: white;
        }

        .btn-primary:hover {
            background: #056f88;
            transform: translateY(-1px);
        }

        .btn-secondary {
            background: #edf2f4;
            color: #405b68;
        }

        .btn-secondary:hover {
            background: #dfe7ea;
        }


        /* =====================================================
           TABLE
        ===================================================== */

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 900px;
        }

        thead {
            background: #0789a8;
            color: white;
        }

        th {
            padding: 14px 12px;
            text-align: left;
            font-size: 13px;
            white-space: nowrap;
        }

        td {
            padding: 13px 12px;
            border-bottom: 1px solid #e5ecef;
            font-size: 13px;
            color: #526873;
        }

        tbody tr:hover {
            background: #f7fbfc;
        }

        .amount {
            font-weight: bold;
            color: #183b4c;
        }


        /* =====================================================
           STATUS BADGES
        ===================================================== */

        .badge {
            display: inline-block;

            padding: 6px 11px;

            border-radius: 20px;

            font-size: 11px;

            font-weight: bold;
        }

        .paid {
            background: #e3f5e9;
            color: #16803c;
        }

        .pending {
            background: #fff4d6;
            color: #9a6b00;
        }

        .partial {
            background: #e7f1ff;
            color: #2563a6;
        }


        /* =====================================================
           DELETE BUTTON
        ===================================================== */

        .delete-btn {
            border: none;

            background: #dc3545;

            color: white;

            padding: 8px 13px;

            border-radius: 7px;

            font-size: 12px;

            font-weight: bold;

            cursor: pointer;

            transition: 0.2s;
        }

        .delete-btn:hover {
            background: #b02a37;
        }


        /* =====================================================
           EMPTY TABLE
        ===================================================== */

        .empty {
            text-align: center;

            padding: 35px;

            color: #82919a;
        }


        /* =====================================================
           MODAL / ALERT
        ===================================================== */

        .modal-overlay {

            position: fixed;

            top: 0;
            left: 0;

            width: 100%;
            height: 100%;

            background: rgba(0,0,0,0.45);

            display: flex;

            justify-content: center;
            align-items: center;

            z-index: 9999;
        }

        .modal-box {

            width: 420px;

            max-width: 90%;

            background: white;

            border-radius: 16px;

            padding: 35px;

            text-align: center;

            box-shadow: 0 15px 40px rgba(0,0,0,0.20);

            animation: popup 0.25s ease;
        }

        @keyframes popup {

            from {
                transform: scale(0.85);
                opacity: 0;
            }

            to {
                transform: scale(1);
                opacity: 1;
            }

        }

        .modal-icon {

            width: 65px;
            height: 65px;

            margin: 0 auto 18px;

            border-radius: 50%;

            display: flex;

            justify-content: center;
            align-items: center;

            font-size: 32px;
        }

        .success-icon {
            background: #e0f5e7;
            color: #16803c;
        }

        .error-icon {
            background: #fde7e7;
            color: #d93025;
        }

        .modal-box h2 {
            color: #183b4c;
            margin-bottom: 10px;
        }

        .modal-box p {
            color: #71828c;
            line-height: 1.5;
            margin-bottom: 22px;
        }

        .modal-buttons {
            display: flex;
            justify-content: center;
            gap: 12px;
        }

        .modal-btn {
            border: none;

            padding: 11px 24px;

            border-radius: 8px;

            cursor: pointer;

            font-weight: bold;
        }

        .ok-btn {
            background: #0789a8;
            color: white;
        }

        .cancel-btn {
            background: #edf2f4;
            color: #405b68;
        }

        .confirm-delete {
            background: #dc3545;
            color: white;
        }


        /* =====================================================
           RESPONSIVE
        ===================================================== */

        @media (max-width: 750px) {

            .navbar {
                padding: 0 20px;
            }

            .user-area {
                display: none;
            }

            .main {
                width: 94%;
                margin: 25px auto;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .full {
                grid-column: 1;
            }

            .card {
                padding: 22px;
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


<!-- =====================================================
     MAIN
===================================================== -->

<div class="main">


    <!-- PAGE HEADER -->

    <div class="page-header">

        <h1>
            Billing Management
        </h1>

        <p>
            Create, view and manage patient billing records.
        </p>

    </div>


    <!-- =================================================
         CREATE BILL
    ================================================= -->

    <div class="card">

        <div class="card-title">

            <h2>
                💳 Create New Bill
            </h2>

            <span class="required-text">
                * Required fields
            </span>

        </div>


        <form action="billing"
              method="post"
              id="billingForm">


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
                        oninput="loadPatient()">

                    <div class="hint">
                        Enter Patient ID to load patient information.
                    </div>

                    <div id="patientStatus"
                         class="status-message">
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
                        placeholder="Patient email"
                        readonly>

                </div>


                <!-- APPOINTMENT ID -->

                <div class="form-group">

                    <label for="appointment_id">
                        Appointment ID
                    </label>

                    <input
                        type="number"
                        id="appointment_id"
                        name="appointment_id"
                        min="1"
                        placeholder="Enter Appointment ID"
                        oninput="loadAppointment()">

                    <div class="hint">
                        Optional. Load appointment information automatically.
                    </div>

                    <div id="appointmentStatus"
                         class="status-message">
                    </div>

                </div>


                <!-- TREATMENT -->

                <div class="form-group">

                    <label for="treatment">
                        Treatment *
                    </label>

                    <input
                        type="text"
                        id="treatment"
                        name="treatment"
                        placeholder="e.g. Dental Cleaning"
                        required>

                </div>


                <!-- AMOUNT -->

                <div class="form-group">

                    <label for="amount">
                        Amount (LKR) *
                    </label>

                    <input
                        type="number"
                        id="amount"
                        name="amount"
                        min="0"
                        step="0.01"
                        placeholder="Enter amount"
                        required>

                </div>


                <!-- PAYMENT METHOD -->

                <div class="form-group">

                    <label for="payment_method">
                        Payment Method *
                    </label>

                    <select
                        id="payment_method"
                        name="payment_method"
                        required>

                        <option value="">
                            Select Payment Method
                        </option>

                        <option value="Cash">
                            Cash
                        </option>

                        <option value="Card">
                            Card
                        </option>

                        <option value="Bank Transfer">
                            Bank Transfer
                        </option>

                        <option value="Online">
                            Online Payment
                        </option>

                    </select>

                </div>


                <!-- PAYMENT STATUS -->

                <div class="form-group">

                    <label for="payment_status">
                        Payment Status *
                    </label>

                    <select
                        id="payment_status"
                        name="payment_status"
                        required>

                        <option value="Pending">
                            Pending
                        </option>

                        <option value="Paid">
                            Paid
                        </option>

                        <option value="Partially Paid">
                            Partially Paid
                        </option>

                    </select>

                </div>


                <!-- NOTES -->

                <div class="form-group full">

                    <label for="notes">
                        Notes
                    </label>

                    <textarea
                        id="notes"
                        name="notes"
                        placeholder="Enter additional billing notes..."></textarea>

                </div>

            </div>


            <!-- BUTTONS -->

            <div class="button-area">

                <button
                    type="submit"
                    class="btn btn-primary">

                    💳 Create Bill

                </button>


                <button
                    type="reset"
                    class="btn btn-secondary"
                    onclick="clearForm()">

                    Clear Form

                </button>

            </div>

        </form>

    </div>


    <!-- =================================================
         BILLING RECORDS
    ================================================= -->

    <div class="card">

        <div class="card-title">

            <h2>
                📋 Billing Records
            </h2>

        </div>


        <div class="table-wrapper">

            <table>

                <thead>

                    <tr>

                        <th>
                            Bill ID
                        </th>

                        <th>
                            Patient ID
                        </th>

                        <th>
                            Patient Name
                        </th>

                        <th>
                            Treatment
                        </th>

                        <th>
                            Amount
                        </th>

                        <th>
                            Payment Method
                        </th>

                        <th>
                            Status
                        </th>

                        <th>
                            Date
                        </th>

                        <th>
                            Action
                        </th>

                    </tr>

                </thead>


                <tbody>

                <%

                    java.sql.ResultSet bills =
                        (java.sql.ResultSet)
                        request.getAttribute("bills");

                    if (bills != null) {

                        boolean hasBills = false;

                        while (bills.next()) {

                            hasBills = true;

                            String paymentStatus =
                                bills.getString("payment_status");

                            String badgeClass = "pending";

                            if ("Paid".equalsIgnoreCase(paymentStatus)) {

                                badgeClass = "paid";

                            } else if
                            ("Partially Paid".equalsIgnoreCase(paymentStatus)) {

                                badgeClass = "partial";
                            }

                %>

                    <tr>

                        <td>
                            <strong>
                                #<%= bills.getInt("bill_id") %>
                            </strong>
                        </td>

                        <td>
                            <%= bills.getInt("patient_id") %>
                        </td>

                        <td>
                            <%= bills.getString("patient_name") %>
                        </td>

                        <td>
                            <%= bills.getString("treatment") %>
                        </td>

                        <td class="amount">

                            LKR
                            <%= bills.getBigDecimal("amount") %>

                        </td>

                        <td>
                            <%= bills.getString("payment_method") %>
                        </td>

                        <td>

                            <span class="badge <%= badgeClass %>">

                                <%= paymentStatus %>

                            </span>

                        </td>

                        <td>

                            <%= bills.getTimestamp("created_at") %>

                        </td>

                       <td>

    <button
        type="button"
        class="delete-btn"
        onclick="openDeleteModal(
            '<%= bills.getInt("bill_id") %>',
            '<%= bills.getString("patient_name")
                       .replace("'", "\\'") %>'
        )">

        🗑 Delete

    </button>

    <button
        type="button"
        class="btn btn-primary"
        style="padding:8px 13px; font-size:12px; margin-left:6px;"
        onclick="printBill(
            '<%= bills.getInt("bill_id") %>',
            '<%= bills.getString("patient_name").replace("'", "\\'") %>',
            '<%= bills.getString("treatment").replace("'", "\\'") %>',
            '<%= bills.getBigDecimal("amount") %>',
            '<%= bills.getString("payment_status") %>'
        )">

        🖨️ Print

    </button>

</td>

                    </tr>

                <%

                        }

                        if (!hasBills) {

                %>

                    <tr>

                        <td colspan="9"
                            class="empty">

                            📋 No billing records found.

                        </td>

                    </tr>

                <%

                        }

                    } else {

                %>

                    <tr>

                        <td colspan="9"
                            class="empty">

                            Unable to load billing records.

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


<!-- =====================================================
     SUCCESS ALERT
===================================================== -->

<% if ("added".equals(success)) { %>

<div class="modal-overlay"
     id="successModal">

    <div class="modal-box">

        <div class="modal-icon success-icon">
            ✓
        </div>

        <h2>
            Bill Created Successfully
        </h2>

        <p>
            The billing record has been successfully
            saved to the database.
        </p>

        <button
            class="modal-btn ok-btn"
            onclick="closeModal('successModal')">

            OK

        </button>

    </div>

</div>

<% } %>


<!-- =====================================================
     DELETE SUCCESS
===================================================== -->

<% if ("deleted".equals(success)) { %>

<div class="modal-overlay"
     id="deleteSuccessModal">

    <div class="modal-box">

        <div class="modal-icon success-icon">
            ✓
        </div>

        <h2>
            Bill Deleted
        </h2>

        <p>
            The billing record has been successfully
            removed from the database.
        </p>

        <button
            class="modal-btn ok-btn"
            onclick="closeModal('deleteSuccessModal')">

            OK

        </button>

    </div>

</div>

<% } %>


<!-- =====================================================
     DATABASE ERROR
===================================================== -->

<% if ("database".equals(error)) { %>

<div class="modal-overlay"
     id="databaseErrorModal">

    <div class="modal-box">

        <div class="modal-icon error-icon">
            !
        </div>

        <h2>
            Database Error
        </h2>

        <p>
            Unable to process the billing request.
            Please check the database connection.
        </p>

        <button
            class="modal-btn ok-btn"
            onclick="closeModal('databaseErrorModal')">

            OK

        </button>

    </div>

</div>

<% } %>


<!-- =====================================================
     DELETE ERROR
===================================================== -->

<% if ("delete".equals(error)) { %>

<div class="modal-overlay"
     id="deleteErrorModal">

    <div class="modal-box">

        <div class="modal-icon error-icon">
            !
        </div>

        <h2>
            Delete Failed
        </h2>

        <p>
            The bill could not be deleted.
            Please try again.
        </p>

        <button
            class="modal-btn ok-btn"
            onclick="closeModal('deleteErrorModal')">

            OK

        </button>

    </div>

</div>

<% } %>


<!-- =====================================================
     VALIDATION ERROR
===================================================== -->

<% if ("patient".equals(error)
       || "treatment".equals(error)
       || "amount".equals(error)) { %>

<div class="modal-overlay"
     id="validationErrorModal">

    <div class="modal-box">

        <div class="modal-icon error-icon">
            !
        </div>

        <h2>
            Invalid Information
        </h2>

        <p>
            Please check the required billing information
            and try again.
        </p>

        <button
            class="modal-btn ok-btn"
            onclick="closeModal('validationErrorModal')">

            OK

        </button>

    </div>

</div>

<% } %>


<!-- =====================================================
     DELETE CONFIRMATION MODAL
===================================================== -->

<div class="modal-overlay"
     id="deleteModal"
     style="display:none;">

    <div class="modal-box">

        <div class="modal-icon error-icon">
            !
        </div>

        <h2>
            Delete Bill?
        </h2>

        <p id="deleteMessage">
            Are you sure you want to delete this bill?
        </p>

        <div class="modal-buttons">

            <button
                type="button"
                class="modal-btn cancel-btn"
                onclick="closeDeleteModal()">

                Cancel

            </button>

            <button
                type="button"
                class="modal-btn confirm-delete"
                onclick="deleteBill()">

                Yes, Delete

            </button>

        </div>

    </div>

</div>


<!-- =====================================================
     JAVASCRIPT
===================================================== -->

<script>

let patientTimer;

let appointmentTimer;

let selectedBillId = null;


/* =====================================================
   LOAD PATIENT
===================================================== */

function loadPatient() {

    clearTimeout(patientTimer);

    const patientId =
        document.getElementById("patient_id").value.trim();

    const status =
        document.getElementById("patientStatus");


    if (patientId === "") {

        clearPatient();

        status.innerHTML = "";

        return;
    }


    status.className =
        "status-message loading";

    status.innerHTML =
        "⏳ Loading patient information...";


    patientTimer = setTimeout(function() {

        fetch(
            "billing?action=getPatient&id="
            + encodeURIComponent(patientId)
        )

        .then(function(response) {

            return response.text();

        })

        .then(function(text) {

            let data;

            try {

                data = JSON.parse(text);

            } catch (error) {

                console.error(
                    "Invalid server response:",
                    text
                );

                throw new Error(
                    "Server did not return JSON."
                );
            }


            if (data.success) {

                document.getElementById(
                    "patient_name"
                ).value =
                    data.patient.patient_name || "";


                document.getElementById(
                    "phone"
                ).value =
                    data.patient.phone || "";


                document.getElementById(
                    "email"
                ).value =
                    data.patient.email || "";


                status.className =
                    "status-message success-text";

                status.innerHTML =
                    "✓ Patient information loaded.";

            } else {

                clearPatient();

                status.className =
                    "status-message error-text";

                status.innerHTML =
                    "✗ "
                    + (
                        data.message ||
                        "Patient not found."
                    );
            }

        })

        .catch(function(error) {

            console.error(
                "Patient loading error:",
                error
            );

            clearPatient();

            status.className =
                "status-message error-text";

            status.innerHTML =
                "✗ Unable to load patient.";

        });

    }, 400);
}


/* =====================================================
   CLEAR PATIENT
===================================================== */

function clearPatient() {

    document.getElementById(
        "patient_name"
    ).value = "";

    document.getElementById(
        "phone"
    ).value = "";

    document.getElementById(
        "email"
    ).value = "";
}


/* =====================================================
   LOAD APPOINTMENT
===================================================== */

function loadAppointment() {

    clearTimeout(appointmentTimer);

    const appointmentId =
        document.getElementById(
            "appointment_id"
        ).value.trim();

    const status =
        document.getElementById(
            "appointmentStatus"
        );


    if (appointmentId === "") {

        status.innerHTML = "";

        return;
    }


    status.className =
        "status-message loading";

    status.innerHTML =
        "⏳ Loading appointment...";


    appointmentTimer = setTimeout(function() {

        fetch(
            "billing?action=getAppointment&id="
            + encodeURIComponent(appointmentId)
        )

        .then(function(response) {

            return response.text();

        })

        .then(function(text) {

            let data;

            try {

                data = JSON.parse(text);

            } catch (error) {

                console.error(
                    "Invalid server response:",
                    text
                );

                throw new Error(
                    "Server did not return JSON."
                );
            }


            if (data.success) {

                const appointment =
                    data.appointment;


                /* Patient ID */

                document.getElementById(
                    "patient_id"
                ).value =
                    appointment.patient_id;


                /* Load patient */

                loadPatient();


                /* Treatment */

                document.getElementById(
                    "treatment"
                ).value =
                    "Dental Appointment - "
                    + (
                        appointment.dentist ||
                        ""
                    );


                status.className =
                    "status-message success-text";

                status.innerHTML =
                    "✓ Appointment information loaded.";

            } else {

                status.className =
                    "status-message error-text";

                status.innerHTML =
                    "✗ "
                    + (
                        data.message ||
                        "Appointment not found."
                    );

            }

        })

        .catch(function(error) {

            console.error(
                "Appointment loading error:",
                error
            );

            status.className =
                "status-message error-text";

            status.innerHTML =
                "✗ Unable to load appointment.";

        });

    }, 400);
}


/* =====================================================
   CLEAR FORM
===================================================== */

function clearForm() {

    setTimeout(function() {

        clearPatient();

        document.getElementById(
            "patientStatus"
        ).innerHTML = "";

        document.getElementById(
            "appointmentStatus"
        ).innerHTML = "";

    }, 50);
}


/* =====================================================
   OPEN DELETE MODAL
===================================================== */

function openDeleteModal(
    billId,
    patientName
) {

    selectedBillId = billId;


    document.getElementById(
        "deleteMessage"
    ).innerHTML =
        "Are you sure you want to delete the bill for <b>"
        + patientName
        + "</b>?";


    document.getElementById(
        "deleteModal"
    ).style.display = "flex";
}


/* =====================================================
   DELETE BILL
===================================================== */

function deleteBill() {

    if (selectedBillId === null) {

        return;
    }


    window.location.href =
        "billing?action=delete&id="
        + encodeURIComponent(
            selectedBillId
        );
}


/* =====================================================
   CLOSE DELETE MODAL
===================================================== */

function closeDeleteModal() {

    selectedBillId = null;

    document.getElementById(
        "deleteModal"
    ).style.display = "none";
}


/* =====================================================
   CLOSE NORMAL MODAL
===================================================== */




function closeModal(id) {

    const modal =
        document.getElementById(id);

    if (modal) {

        modal.remove();
    }

}

function printBill(billId, patientName, treatment, amount, status) {

    const printWindow = window.open('', '', 'width=600,height=700');

    printWindow.document.write(`
        <html>
        <head>
            <title>Bill Receipt #${billId}</title>
            <style>
                body { font-family: Arial, sans-serif; padding: 30px; }
                h2 { color: #0789a8; }
                table { width: 100%; margin-top: 20px; border-collapse: collapse; }
                td { padding: 8px; border-bottom: 1px solid #ddd; }
            </style>
        </head>
        <body>
            <h2>🦷 Sunrise Dental Clinic</h2>
            <p>Official Bill Receipt</p>
            <table>
                <tr><td><b>Bill ID</b></td><td>#${billId}</td></tr>
                <tr><td><b>Patient Name</b></td><td>${patientName}</td></tr>
                <tr><td><b>Treatment</b></td><td>${treatment}</td></tr>
                <tr><td><b>Amount</b></td><td>LKR ${amount}</td></tr>
                <tr><td><b>Payment Status</b></td><td>${status}</td></tr>
            </table>
        </body>
        </html>
    `);

    printWindow.document.close();
    printWindow.print();
}

</script>


</body>

</html>