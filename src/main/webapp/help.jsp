<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help - Sunrise Dental Clinic</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: Arial, Helvetica, sans-serif; }
        body { background: #f7fbfd; color: #163b4d; padding: 40px; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 40px;
                     border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.08); }
        h1 { color: #0787a7; margin-bottom: 10px; }
        .subtitle { color: #6d7d87; margin-bottom: 30px; }
        .step { margin-bottom: 25px; padding: 15px; background: #eaf8fc; border-radius: 10px;
                border-left: 4px solid #0ca8c4; }
        .step h3 { color: #123c50; margin-bottom: 8px; }
        .step p { color: #33505d; line-height: 1.5; }
        .back-link { display: inline-block; margin-top: 20px; padding: 10px 20px;
                     background: #087fa0; color: white; text-decoration: none; border-radius: 8px; }
        .back-link:hover { background: #079dbb; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Help &amp; User Guide</h1>
        <p class="subtitle">Step-by-step instructions for new staff members</p>

        <div class="step">
            <h3>1. Logging In</h3>
            <p>Enter your assigned username and password on the login page, then click "Sign In".
               Only authorized staff accounts can access the system.</p>
        </div>

        <div class="step">
            <h3>2. Registering a New Appointment</h3>
            <p>From the dashboard, click "Register Appointment". Fill in the patient's name, address,
               contact number, dentist name, treatment type, and the appointment date/time.
               All fields marked required must be filled correctly before submitting.</p>
        </div>

        <div class="step">
            <h3>3. Searching an Appointment</h3>
            <p>Go to "Search Appointment" and enter the Appointment ID. The system will display
               the full patient and appointment details linked to that ID.</p>
        </div>

        <div class="step">
            <h3>4. Generating a Bill</h3>
            <p>Open "Billing", enter the Appointment ID, and the system will calculate the total
               cost based on the treatment type and consultation fee. You can then print or save
               the receipt.</p>
        </div>

        <div class="step">
            <h3>5. Logging Out</h3>
            <p>Click the "Logout" button at any time to safely end your session and return to the
               login page.</p>
        </div>

        <a href="${pageContext.request.contextPath}/dashboard.jsp" class="back-link">← Back to Dashboard</a>
    </div>
</body>
</html>