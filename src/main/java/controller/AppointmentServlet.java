package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import util.DBConnection;

@WebServlet("/appointments")
public class AppointmentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // GET REQUEST
    // =========================================================
    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // =====================================================
        // GET PATIENT DETAILS BY PATIENT ID
        // =====================================================
        if ("getPatient".equals(action)) {

            String patientId = request.getParameter("patient_id");

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            if (patientId == null || patientId.trim().isEmpty()) {
                response.getWriter().write(
                    "{\"success\":false,\"message\":\"Patient ID is required\"}"
                );
                return;
            }

            String sql = "SELECT patient_id, patient_name, phone, email "
                       + "FROM patients WHERE patient_id = ?";

            try (Connection connection = DBConnection.getConnection();
                 PreparedStatement statement = connection.prepareStatement(sql)) {

                statement.setInt(1, Integer.parseInt(patientId));

                try (ResultSet result = statement.executeQuery()) {

                    if (result.next()) {

                        String name = result.getString("patient_name");
                        String phone = result.getString("phone");
                        String email = result.getString("email");

                        // Avoid null values in JSON
                        if (name == null) name = "";
                        if (phone == null) phone = "";
                        if (email == null) email = "";

                        name = escapeJson(name);
                        phone = escapeJson(phone);
                        email = escapeJson(email);

                        String json =
                                "{"
                                + "\"success\":true,"
                                + "\"patient_id\":" + result.getInt("patient_id") + ","
                                + "\"patient_name\":\"" + name + "\","
                                + "\"phone\":\"" + phone + "\","
                                + "\"email\":\"" + email + "\""
                                + "}";

                        response.getWriter().write(json);

                    } else {

                        response.getWriter().write(
                            "{\"success\":false,\"message\":\"Patient not found\"}"
                        );
                    }
                }

            } catch (NumberFormatException e) {

                response.getWriter().write(
                    "{\"success\":false,\"message\":\"Invalid Patient ID\"}"
                );

            } catch (Exception e) {

                e.printStackTrace();

                response.getWriter().write(
                    "{\"success\":false,\"message\":\"Database error\"}"
                );
            }

            return;
        }

        // =====================================================
        // DELETE APPOINTMENT
        // =====================================================
        if ("delete".equals(action)) {

            String id = request.getParameter("id");

            if (id != null && !id.trim().isEmpty()) {

                String sql =
                    "DELETE FROM appointments WHERE appointment_id = ?";

                try (Connection connection = DBConnection.getConnection();
                     PreparedStatement statement =
                         connection.prepareStatement(sql)) {

                    statement.setInt(1, Integer.parseInt(id));
                    statement.executeUpdate();

                } catch (Exception e) {

                    e.printStackTrace();
                }
            }

            response.sendRedirect("appointments");
            return;
        }

        // =====================================================
        // DISPLAY ALL APPOINTMENTS
        // =====================================================

        String sql =
            "SELECT * FROM appointments "
          + "ORDER BY appointment_date, appointment_time";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                 connection.prepareStatement(sql);
             ResultSet result = statement.executeQuery()) {

            request.setAttribute("appointments", result);

            request.getRequestDispatcher("appointments.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "appointments.jsp?error=database"
            );
        }
    }

    // =========================================================
    // POST REQUEST - ADD APPOINTMENT
    // (NOW VALIDATES PATIENT EXISTENCE, PAST DATES, AND
    //  CHECKS FOR DENTIST DOUBLE-BOOKING BEFORE INSERTING)
    // =========================================================
    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String patientIdParam = request.getParameter("patient_id");
        String patientName = request.getParameter("patient_name");
        String appointmentDate =
            request.getParameter("appointment_date");
        String appointmentTime =
            request.getParameter("appointment_time");
        String dentist = request.getParameter("dentist");
        String status = request.getParameter("status");
        String notes = request.getParameter("notes");

        // =====================================================
        // BASIC FIELD VALIDATION
        // =====================================================

        if (patientIdParam == null || patientIdParam.trim().isEmpty()) {

            response.sendRedirect(
                "appointments.jsp?error=patient"
            );
            return;
        }

        if (appointmentDate == null ||
            appointmentDate.trim().isEmpty()) {

            response.sendRedirect(
                "appointments.jsp?error=date"
            );
            return;
        }

        if (appointmentTime == null ||
            appointmentTime.trim().isEmpty()) {

            response.sendRedirect(
                "appointments.jsp?error=time"
            );
            return;
        }

        if (dentist == null ||
            dentist.trim().isEmpty()) {

            response.sendRedirect(
                "appointments.jsp?error=dentist"
            );
            return;
        }

        dentist = dentist.trim();

        // =====================================================
        // VALIDATE PATIENT ID IS A NUMBER
        // =====================================================

        int patientId;

        try {
            patientId = Integer.parseInt(patientIdParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(
                "appointments.jsp?error=patient"
            );
            return;
        }

        // =====================================================
        // VALIDATE APPOINTMENT DATE IS NOT IN THE PAST
        // =====================================================

        try {
            LocalDate requestedDate = LocalDate.parse(appointmentDate.trim());

            if (requestedDate.isBefore(LocalDate.now())) {
                response.sendRedirect(
                    "appointments.jsp?error=pastdate"
                );
                return;
            }
        } catch (Exception e) {
            response.sendRedirect(
                "appointments.jsp?error=date"
            );
            return;
        }

        Connection connection = null;

        try {

            connection = DBConnection.getConnection();

            if (connection == null) {
                response.sendRedirect(
                    "appointments.jsp?error=database"
                );
                return;
            }

            // -------------------------------------------------
            // STEP 1: Confirm the patient actually exists
            // before creating an appointment for them.
            // -------------------------------------------------
            String patientCheckSql =
                "SELECT patient_id FROM patients WHERE patient_id = ?";

            boolean patientExists = false;

            try (PreparedStatement patientCheckStmt =
                    connection.prepareStatement(patientCheckSql)) {

                patientCheckStmt.setInt(1, patientId);

                try (ResultSet patientResult =
                        patientCheckStmt.executeQuery()) {

                    patientExists = patientResult.next();
                }
            }

            if (!patientExists) {
                response.sendRedirect(
                    "appointments.jsp?error=patientnotfound"
                );
                return;
            }

            // -------------------------------------------------
            // STEP 2: Check whether the same dentist already
            // has an appointment at the same date and time.
            // This mirrors the UNIQUE (dentist, appointment_date,
            // appointment_time) constraint in the database, but
            // gives the user a clear message instead of a raw
            // SQL error.
            // -------------------------------------------------
            String conflictSql =
                "SELECT appointment_id FROM appointments " +
                "WHERE dentist = ? AND appointment_date = ? " +
                "AND appointment_time = ? AND status <> 'Cancelled'";

            boolean slotTaken = false;

            try (PreparedStatement conflictStmt =
                    connection.prepareStatement(conflictSql)) {

                conflictStmt.setString(1, dentist);
                conflictStmt.setString(2, appointmentDate);
                conflictStmt.setString(3, appointmentTime);

                try (ResultSet conflictResult =
                        conflictStmt.executeQuery()) {

                    slotTaken = conflictResult.next();
                }
            }

            if (slotTaken) {
                response.sendRedirect(
                    "appointments.jsp?error=slotunavailable"
                );
                return;
            }

            // -------------------------------------------------
            // STEP 3: Safe to insert the new appointment.
            // -------------------------------------------------
            String insertSql =
                "INSERT INTO appointments "
              + "(patient_id, patient_name, appointment_date, "
              + "appointment_time, dentist, status, notes) "
              + "VALUES (?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement statement =
                     connection.prepareStatement(insertSql)) {

                statement.setInt(1, patientId);
                statement.setString(2, patientName);
                statement.setString(3, appointmentDate);
                statement.setString(4, appointmentTime);
                statement.setString(5, dentist);
                statement.setString(6, status);
                statement.setString(7, notes);

                statement.executeUpdate();
            }

            response.sendRedirect(
                "appointments?success=1"
            );

        } catch (Exception e) {

            e.printStackTrace();

            // If the database UNIQUE constraint still catches a
            // rare race-condition duplicate booking, this
            // redirect handles it gracefully instead of the
            // application crashing.
            response.sendRedirect(
                "appointments.jsp?error=database"
            );

        } finally {

            if (connection != null) {
                try {
                    connection.close();
                } catch (Exception ignored) {
                }
            }
        }
    }

    // =========================================================
    // ESCAPE JSON SPECIAL CHARACTERS
    // =========================================================
    private String escapeJson(String value) {

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}
