<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Patients | Sunrise Dental Clinic</title>

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

        .header {
            height: 70px;
            background: #0789a8;
            color: white;

            display: flex;
            align-items: center;
            justify-content: space-between;

            padding: 0 40px;

            box-shadow: 0 3px 12px rgba(0,0,0,0.12);
        }

        .logo {
            font-size: 23px;
            font-weight: bold;
        }

        .back-btn {
            color: white;
            text-decoration: none;

            padding: 10px 18px;

            border: 1px solid rgba(255,255,255,0.5);

            border-radius: 7px;

            transition: 0.2s;
        }

        .back-btn:hover {
            background: rgba(255,255,255,0.15);
        }


        /* =========================
           MAIN
        ========================= */

        .container {
            width: 90%;
            max-width: 1200px;

            margin: 35px auto;
        }

        .page-title {
            margin-bottom: 25px;
        }

        .page-title h1 {
            color: #123b4a;
            font-size: 32px;
            margin-bottom: 8px;
        }

        .page-title p {
            color: #71828c;
            font-size: 15px;
        }


        /* =========================
           ALERT
        ========================= */

        .alert {
            position: relative;

            padding: 16px 45px 16px 18px;

            border-radius: 9px;

            margin-bottom: 22px;

            font-size: 15px;

            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
        }

        .success-alert {
            background: #dff5e5;
            color: #176b35;
            border: 1px solid #b8e5c4;
        }

        .error-alert {
            background: #fde2e2;
            color: #9b1c1c;
            border: 1px solid #f3b7b7;
        }

        .close-alert {
            position: absolute;

            right: 15px;
            top: 12px;

            border: none;
            background: transparent;

            font-size: 20px;

            cursor: pointer;

            color: inherit;
        }


        /* =========================
           CARD
        ========================= */

        .card {
            background: white;

            border-radius: 15px;

            padding: 30px;

            margin-bottom: 30px;

            box-shadow:
                0 5px 20px rgba(0,0,0,0.06);
        }

        .card-title {
            color: #0789a8;

            font-size: 22px;

            margin-bottom: 25px;
        }


        /* =========================
           FORM
        ========================= */

        .form-grid {
            display: grid;

            grid-template-columns: 1fr 1fr;

            gap: 20px;
        }

        .form-group {
            display: flex;

            flex-direction: column;
        }

        .full {
            grid-column: 1 / 3;
        }

        label {
            font-size: 14px;

            font-weight: bold;

            color: #234b5d;

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

        textarea {
            min-height: 100px;

            resize: vertical;
        }


        /* =========================
           BUTTON
        ========================= */

        .btn-container {
            margin-top: 25px;
        }

        .btn {

            background: #0789a8;

            color: white;

            border: none;

            padding: 13px 24px;

            border-radius: 8px;

            font-size: 15px;

            font-weight: bold;

            cursor: pointer;

            transition: 0.2s;
        }

        .btn:hover {
            background: #056f89;

            transform: translateY(-1px);
        }


        /* =========================
           PATIENT TABLE
        ========================= */

        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;

            border-collapse: collapse;

            margin-top: 10px;
        }

        th {
            background: #eaf7fa;

            color: #075b70;

            font-size: 14px;

            text-align: left;

            padding: 14px;
        }

        td {
            padding: 14px;

            border-bottom: 1px solid #edf1f3;

            color: #4c6572;

            font-size: 14px;
        }

        tr:hover {
            background: #f8fcfd;
        }

        .patient-id {
            font-weight: bold;

            color: #0789a8;
        }

        .delete-btn {

            display: inline-block;

            background: #e74c3c;

            color: white;

            text-decoration: none;

            padding: 7px 12px;

            border-radius: 6px;

            font-size: 12px;

            transition: 0.2s;
        }

        .delete-btn:hover {
            background: #c0392b;
        }

        .empty-message {

            text-align: center;

            padding: 35px;

            color: #7b8b94;
        }


        /* =========================
           RESPONSIVE
        ========================= */

        @media (max-width: 750px) {

            .header {
                padding: 0 20px;
            }

            .logo {
                font-size: 18px;
            }

            .container {
                width: 94%;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .full {
                grid-column: 1;
            }

            .page-title h1 {
                font-size: 27px;
            }

            .card {
                padding: 20px;
            }
        }

    </style>

</head>


<body>


<!-- =========================
     HEADER
========================= -->

<div class="header">

    <div class="logo">
        🦷 Sunrise Dental Clinic
    </div>

    <a href="dashboard.jsp" class="back-btn">
        ← Back to Dashboard
    </a>

</div>


<!-- =========================
     MAIN CONTAINER
========================= -->

<div class="container">


    <!-- PAGE TITLE -->

    <div class="page-title">

        <h1>
            Patient Management
        </h1>

        <p>
            Add and manage patient information securely.
        </p>

    </div>


    <!-- =========================
         SUCCESS ALERT
    ========================= -->

    <% if ("1".equals(success)) { %>

        <div class="alert success-alert">

            ✓
            <strong>Success!</strong>
            Patient information has been added successfully.

            <button class="close-alert"
                    onclick="this.parentElement.style.display='none'">
                ×
            </button>

        </div>

    <% } %>


    <!-- =========================
         DATABASE ERROR
    ========================= -->

    <% if ("database".equals(error)) { %>

        <div class="alert error-alert">

            ✗
            <strong>Database Error!</strong>
            Unable to save patient information.
            Please check the database connection and try again.

            <button class="close-alert"
                    onclick="this.parentElement.style.display='none'">
                ×
            </button>

        </div>

    <% } %>


    <!-- =========================
         INVALID AGE
    ========================= -->

    <% if ("invalidage".equals(error)) { %>

        <div class="alert error-alert">

            ✗
            <strong>Invalid Age!</strong>
            Please enter a valid number for the patient's age.

            <button class="close-alert"
                    onclick="this.parentElement.style.display='none'">
                ×
            </button>

        </div>

    <% } %>



    <!-- =========================
         ADD PATIENT CARD
    ========================= -->

    <div class="card">

        <h2 class="card-title">
            Add New Patient
        </h2>


        <form action="patients"
              method="post"
              onsubmit="return validateForm();">


            <div class="form-grid">


                <!-- PATIENT NAME -->

                <div class="form-group">

                    <label for="patient_name">
                        Patient Name *
                    </label>

                    <input
                        type="text"
                        id="patient_name"
                        name="patient_name"
                        placeholder="Enter patient name"
                        required>

                </div>


                <!-- AGE -->

                <div class="form-group">

                    <label for="age">
                        Age
                    </label>

                    <input
                        type="number"
                        id="age"
                        name="age"
                        placeholder="Enter patient age"
                        min="0"
                        max="120">

                </div>


                <!-- GENDER -->

                <div class="form-group">

                    <label for="gender">
                        Gender
                    </label>

                    <select
                        id="gender"
                        name="gender">

                        <option value="">
                            Select Gender
                        </option>

                        <option value="Male">
                            Male
                        </option>

                        <option value="Female">
                            Female
                        </option>

                        <option value="Other">
                            Other
                        </option>

                    </select>

                </div>


                <!-- PHONE -->

                <div class="form-group">

                    <label for="phone">
                        Phone Number
                    </label>

                    <input
                        type="tel"
                        id="phone"
                        name="phone"
                        placeholder="Enter phone number"
                        maxlength="20">

                </div>


                <!-- EMAIL -->

                <div class="form-group">

                    <label for="email">
                        Email Address
                    </label>

                    <input
                        type="email"
                        id="email"
                        name="email"
                        placeholder="Enter email address">

                </div>


                <!-- ADDRESS -->

                <div class="form-group">

                    <label for="address">
                        Address
                    </label>

                    <input
                        type="text"
                        id="address"
                        name="address"
                        placeholder="Enter patient address">

                </div>


                <!-- MEDICAL HISTORY -->

                <div class="form-group full">

                    <label for="medical_history">
                        Medical History
                    </label>

                    <textarea
                        id="medical_history"
                        name="medical_history"
                        placeholder="Enter relevant medical history..."></textarea>

                </div>


            </div>


            <!-- BUTTON -->

            <div class="btn-container">

                <button
                    type="submit"
                    class="btn">

                    + Add Patient

                </button>

            </div>


        </form>

    </div>



    <!-- =========================
         PATIENT LIST
    ========================= -->

    <div class="card">

        <h2 class="card-title">
            Patient Records
        </h2>


        <div class="table-wrapper">

            <table>

                <thead>

                    <tr>

                        <th>
                            Patient ID
                        </th>

                        <th>
                            Patient Name
                        </th>

                        <th>
                            Age
                        </th>

                        <th>
                            Gender
                        </th>

                        <th>
                            Phone
                        </th>

                        <th>
                            Email
                        </th>

                        <th>
                            Address
                        </th>

                        <th>
                            Action
                        </th>

                    </tr>

                </thead>


                <tbody>

                <%
                    java.sql.ResultSet patients =
                        (java.sql.ResultSet) request.getAttribute("patients");

                    if (patients != null) {

                        boolean hasPatients = false;

                        while (patients.next()) {

                            hasPatients = true;
                %>

                    <tr>

                        <td class="patient-id">
                            <%= patients.getInt("patient_id") %>
                        </td>

                        <td>
                            <%= patients.getString("patient_name") != null
                                ? patients.getString("patient_name")
                                : "" %>
                        </td>

                        <td>
                            <%= patients.getObject("age") != null
                                ? patients.getInt("age")
                                : "" %>
                        </td>

                        <td>
                            <%= patients.getString("gender") != null
                                ? patients.getString("gender")
                                : "" %>
                        </td>

                        <td>
                            <%= patients.getString("phone") != null
                                ? patients.getString("phone")
                                : "" %>
                        </td>

                        <td>
                            <%= patients.getString("email") != null
                                ? patients.getString("email")
                                : "" %>
                        </td>

                        <td>
                            <%= patients.getString("address") != null
                                ? patients.getString("address")
                                : "" %>
                        </td>

                        <td>

                            <a
                                href="patients?action=delete&id=<%= patients.getInt("patient_id") %>"
                                class="delete-btn"
                                onclick="return confirm('Are you sure you want to delete this patient?');">

                                Delete

                            </a>

                        </td>

                    </tr>

                <%
                        }

                        if (!hasPatients) {
                %>

                    <tr>

                        <td colspan="8"
                            class="empty-message">

                            No patient records found.

                        </td>

                    </tr>

                <%
                        }

                    } else {
                %>

                    <tr>

                        <td colspan="8"
                            class="empty-message">

                            No patient records available.

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


<!-- =========================
     JAVASCRIPT
========================= -->

<script>

    function validateForm() {

        const patientName =
            document.getElementById("patient_name").value.trim();

        const age =
            document.getElementById("age").value;

        const phone =
            document.getElementById("phone").value.trim();


        if (patientName === "") {

            alert("Please enter the patient name.");

            return false;
        }


        if (age !== "") {

            const ageNumber = parseInt(age);

            if (ageNumber < 0 || ageNumber > 120) {

                alert("Please enter a valid age between 0 and 120.");

                return false;
            }
        }


        if (phone !== "") {

            const phonePattern = /^[0-9+\-\s()]+$/;

            if (!phonePattern.test(phone)) {

                alert("Please enter a valid phone number.");

                return false;
            }
        }


        return true;
    }

</script>


</body>

</html>