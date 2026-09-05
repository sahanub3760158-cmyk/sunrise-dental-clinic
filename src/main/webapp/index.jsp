<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Sunrise Dental Clinic | Login</title>

    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, Helvetica, sans-serif;
        }

        body {
            min-height: 100vh;
            background: linear-gradient(
                135deg,
                #eaf8fc,
                #f7fbfd
            );

            display: flex;
            align-items: center;
            justify-content: center;

            color: #163b4d;
        }

        /* Main Container */

        .container {
            width: 900px;
            max-width: 94%;

            min-height: 580px;

            background: white;

            border-radius: 25px;

            overflow: hidden;

            display: flex;

            box-shadow:
                0 20px 60px rgba(0, 0, 0, 0.12);
        }


        /* Left Section */

        .welcome-section {
            width: 52%;

            background: linear-gradient(
                145deg,
                #0787a7,
                #0ca8c4
            );

            color: white;

            padding: 70px 50px;

            display: flex;

            flex-direction: column;

            justify-content: center;
        }


        /* Tooth Icon */

        .logo-circle {

            width: 82px;
            height: 82px;

            background: rgba(255,255,255,0.18);

            border-radius: 50%;

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 43px;

            margin-bottom: 30px;
        }


        .welcome-section h1 {

            font-size: 38px;

            line-height: 1.2;

            margin-bottom: 18px;

            font-weight: 700;
        }


        .welcome-section .subtitle {

            font-size: 18px;

            line-height: 1.6;

            margin-bottom: 38px;

            color: rgba(255,255,255,0.95);
        }


        /* Features */

        .features {

            display: flex;

            flex-direction: column;

            gap: 18px;
        }


        .feature {

            display: flex;

            align-items: center;

            font-size: 16px;
        }


        .check {

            width: 25px;
            height: 25px;

            border-radius: 50%;

            background: rgba(255,255,255,0.18);

            display: flex;

            align-items: center;

            justify-content: center;

            margin-right: 12px;

            font-size: 13px;
        }


        /* Right Login Section */

        .login-section {

            width: 48%;

            padding: 65px 55px;

            display: flex;

            flex-direction: column;

            justify-content: center;
        }


        .login-section h2 {

            font-size: 34px;

            margin-bottom: 10px;

            color: #123c50;
        }


        .login-description {

            color: #6d7d87;

            font-size: 15px;

            margin-bottom: 35px;
        }


        /* Error Message */

        .error-message {

            background: #fff0f0;

            border: 1px solid #ffcaca;

            color: #d93030;

            padding: 12px 15px;

            border-radius: 8px;

            margin-bottom: 20px;

            font-size: 14px;
        }


        /* Form */

        .login-form {

            width: 100%;
        }


        .form-group {

            margin-bottom: 22px;
        }


        .form-group label {

            display: block;

            margin-bottom: 9px;

            font-size: 15px;

            font-weight: 600;

            color: #233f4c;
        }


        .form-group input {

            width: 100%;

            height: 53px;

            padding: 0 16px;

            border: 1px solid #d5dde2;

            border-radius: 10px;

            font-size: 15px;

            outline: none;

            transition: all 0.25s ease;

            color: #233f4c;

            background: #ffffff;
        }


        .form-group input:focus {

            border-color: #08a3c2;

            box-shadow:
                0 0 0 3px rgba(8,163,194,0.12);
        }


        .form-group input::placeholder {

            color: #9aa6ad;
        }


        /* Login Button */

        .login-btn {

            width: 100%;

            height: 53px;

            border: none;

            border-radius: 10px;

            background: linear-gradient(
                135deg,
                #087fa0,
                #079dbb
            );

            color: white;

            font-size: 16px;

            font-weight: 700;

            cursor: pointer;

            transition: all 0.25s ease;

            box-shadow:
                0 7px 18px rgba(8, 143, 171, 0.25);
        }


        .login-btn:hover {

            transform: translateY(-2px);

            box-shadow:
                0 10px 25px rgba(8, 143, 171, 0.32);
        }


        .login-btn:active {

            transform: translateY(0);
        }


        /* Footer */

        .authorized {

            text-align: center;

            margin-top: 25px;

            color: #71818a;

            font-size: 14px;
        }


        .copyright {

            text-align: center;

            margin-top: 38px;

            color: #a0abb1;

            font-size: 13px;
        }


        /* Responsive */

        @media (max-width: 750px) {

            .container {

                flex-direction: column;

                width: 95%;

                margin: 25px 0;
            }

            .welcome-section,
            .login-section {

                width: 100%;
            }

            .welcome-section {

                padding: 45px 35px;
            }

            .login-section {

                padding: 45px 35px;
            }

            .welcome-section h1 {

                font-size: 30px;
            }
        }


    </style>

</head>


<body>


    <div class="container">


        <!-- ========================= -->
        <!-- LEFT WELCOME SECTION -->
        <!-- ========================= -->

        <div class="welcome-section">


            <div class="logo-circle">
                🦷
            </div>


            <h1>
                Sunrise Dental Clinic
            </h1>


            <p class="subtitle">
                Appointment &amp; Patient Management System
            </p>


            <div class="features">


                <div class="feature">

                    <div class="check">
                        ✓
                    </div>

                    <span>
                        Secure Staff Access
                    </span>

                </div>


                <div class="feature">

                    <div class="check">
                        ✓
                    </div>

                    <span>
                        Appointment Management
                    </span>

                </div>


                <div class="feature">

                    <div class="check">
                        ✓
                    </div>

                    <span>
                        Patient Records
                    </span>

                </div>


                <div class="feature">

                    <div class="check">
                        ✓
                    </div>

                    <span>
                        Billing &amp; Receipts
                    </span>

                </div>


            </div>


        </div>


        <!-- ========================= -->
        <!-- RIGHT LOGIN SECTION -->
        <!-- ========================= -->

        <div class="login-section">


            <h2>
                Welcome Back
            </h2>


            <p class="login-description">
                Sign in to access the clinic management system.
            </p>


            <!-- Error Messages -->

            <!-- Error Messages -->

<%
    String error = request.getParameter("error");

    if ("invalid".equals(error)) {
%>

    <script>
        alert("Invalid username or password. Please try again.");
    </script>

    <div class="error-message">
        Invalid username or password.
    </div>

<%
    } else if ("database".equals(error)) {
%>

    <script>
        alert("Database connection error. Please try again.");
    </script>

    <div class="error-message">
        Database connection error. Please try again.
    </div>

<%
    }
%>


            <!-- ========================= -->
            <!-- LOGIN FORM -->
            <!-- ========================= -->

            <form
                class="login-form"
                action="${pageContext.request.contextPath}/login"
                method="post">


                <!-- Username -->

                <div class="form-group">

                    <label for="username">
                        Username
                    </label>

                    <input
                        type="text"
                        id="username"
                        name="username"
                        placeholder="Enter your username"
                        autocomplete="username"
                        required>

                </div>


                <!-- Password -->

                <div class="form-group">

                    <label for="password">
                        Password
                    </label>

                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Enter your password"
                        autocomplete="current-password"
                        required>

                </div>


                <!-- Sign In -->

                <button
                    type="submit"
                    class="login-btn">

                    Sign In

                </button>


            </form>


            <p class="authorized">
                Authorized clinic staff only
            </p>


            <p class="copyright">
                &copy; 2026 Sunrise Dental Clinic
            </p>


        </div>


    </div>


</body>

</html>