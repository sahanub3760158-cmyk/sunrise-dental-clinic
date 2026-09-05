package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import util.DBConnection;

@WebServlet("/patients")
public class PatientServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // GET
    // =========================================================
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // =====================================================
        // LOAD SINGLE PATIENT AS JSON
        // URL:
        // /patients?action=get&id=1
        // =====================================================
        if ("get".equals(action)) {

            getPatientById(request, response);
            return;
        }
        
        
     // =====================================================
     // DELETE PATIENT
     // URL: /patients?action=delete&id=17
     // =====================================================
     if ("delete".equals(action)) {

         deletePatient(request, response);
         return;
     }

        // =====================================================
        // DISPLAY ALL PATIENTS
        // =====================================================
        String sql =
                "SELECT patient_id, patient_name, age, gender, " +
                "phone, email, address, medical_history, created_at " +
                "FROM patients ORDER BY patient_id DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql);
             ResultSet result = statement.executeQuery()) {

            request.setAttribute("patients", result);

            request.getRequestDispatcher("patients.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "patients.jsp?error=database"
            );
        }
    }

    // =========================================================
    // GET PATIENT BY ID
    // RETURN JSON
    // =========================================================
    private void getPatientById(HttpServletRequest request,
                                HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        String id = request.getParameter("id");

        // -----------------------------------------------------
        // Validate ID
        // -----------------------------------------------------
        if (id == null || id.trim().isEmpty()) {

            out.print(
                "{\"success\":false," +
                "\"message\":\"Patient ID is required.\"}"
            );

            out.flush();
            return;
        }

        int patientId;

        try {

            patientId = Integer.parseInt(id);

        } catch (NumberFormatException e) {

            out.print(
                "{\"success\":false," +
                "\"message\":\"Invalid Patient ID.\"}"
            );

            out.flush();
            return;
        }

        // -----------------------------------------------------
        // SQL
        // -----------------------------------------------------
        String sql =
                "SELECT patient_id, patient_name, phone, email " +
                "FROM patients WHERE patient_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, patientId);

            try (ResultSet result = statement.executeQuery()) {

                if (result.next()) {

                    String patientName =
                            result.getString("patient_name");

                    String phone =
                            result.getString("phone");

                    String email =
                            result.getString("email");

                    // Prevent JSON problems caused by quotes
                    patientName = escapeJson(patientName);
                    phone = escapeJson(phone);
                    email = escapeJson(email);

                    String json =
                            "{"
                            + "\"success\":true,"
                            + "\"patient\":{"
                            + "\"patient_id\":" + patientId + ","
                            + "\"patient_name\":\"" + patientName + "\","
                            + "\"phone\":\"" + phone + "\","
                            + "\"email\":\"" + email + "\""
                            + "}"
                            + "}";

                    out.print(json);

                } else {

                    out.print(
                        "{\"success\":false," +
                        "\"message\":\"Patient not found.\"}"
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            out.print(
                "{\"success\":false," +
                "\"message\":\"Database error.\"}"
            );
        }

        out.flush();
    }
    
    
    
 // =========================================================
 // DELETE PATIENT BY ID
 // =========================================================
 private void deletePatient(HttpServletRequest request,
                            HttpServletResponse response)
         throws IOException {

     String id = request.getParameter("id");

     if (id == null || id.trim().isEmpty()) {
         response.sendRedirect("patients?error=invalidid");
         return;
     }

     int patientId;

     try {
         patientId = Integer.parseInt(id);
     } catch (NumberFormatException e) {
         response.sendRedirect("patients?error=invalidid");
         return;
     }

     String deleteSql =
             "DELETE FROM patients WHERE patient_id = ?";

     try (Connection connection = DBConnection.getConnection();
          PreparedStatement statement =
                  connection.prepareStatement(deleteSql)) {

         statement.setInt(1, patientId);

         int rowsDeleted = statement.executeUpdate();

         if (rowsDeleted == 1) {
             response.sendRedirect("patients?success=deleted");
         } else {
             response.sendRedirect("patients?error=notfound");
         }

     } catch (Exception e) {

         e.printStackTrace();

         response.sendRedirect("patients?error=cannotdelete");
     }
 }

    // =========================================================
    // POST
    // ADD NEW PATIENT
    // (NOW CHECKS FOR EXISTING PATIENT BY PHONE + NAME
    //  BEFORE INSERTING - PREVENTS DUPLICATE RECORDS)
    // =========================================================
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String patientName =
                request.getParameter("patient_name");

        String age =
                request.getParameter("age");

        String gender =
                request.getParameter("gender");

        String phone =
                request.getParameter("phone");

        String email =
                request.getParameter("email");

        String address =
                request.getParameter("address");

        String medicalHistory =
                request.getParameter("medical_history");

        // -----------------------------------------------------
        // Basic validation - reject blank required fields
        // -----------------------------------------------------
        if (patientName == null || patientName.trim().isEmpty()
                || phone == null || phone.trim().isEmpty()) {

            response.sendRedirect(
                    "patients.jsp?error=missingfields"
            );
            return;
        }

        patientName = patientName.trim();
        phone = phone.trim();

        Connection connection = null;

        try {

            connection = DBConnection.getConnection();

            // ---------------------------------------------------
            // STEP 1: Check whether a patient with the SAME
            // phone number AND the SAME name already exists.
            // ---------------------------------------------------
            String checkSql =
                    "SELECT patient_id FROM patients " +
                    "WHERE phone = ? AND patient_name = ?";

            int existingPatientId = -1;

            try (PreparedStatement checkStatement =
                         connection.prepareStatement(checkSql)) {

                checkStatement.setString(1, phone);
                checkStatement.setString(2, patientName);

                try (ResultSet checkResult =
                             checkStatement.executeQuery()) {

                    if (checkResult.next()) {
                        existingPatientId =
                                checkResult.getInt("patient_id");
                    }
                }
            }

            // ---------------------------------------------------
            // STEP 2A: Patient already exists -> do NOT insert
            // again. Just redirect back with a message so the
            // existing record is reused instead of duplicated.
            // ---------------------------------------------------
            if (existingPatientId != -1) {

                response.sendRedirect(
                        "patients?success=existing&id=" + existingPatientId
                );
                return;
            }

            // ---------------------------------------------------
            // STEP 2B: No matching patient found -> safe to
            // insert a brand new patient record.
            // ---------------------------------------------------
            String insertSql =
                    "INSERT INTO patients " +
                    "(patient_name, age, gender, phone, email, " +
                    "address, medical_history) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement insertStatement =
                         connection.prepareStatement(
                                 insertSql,
                                 Statement.RETURN_GENERATED_KEYS)) {

                insertStatement.setString(1, patientName);

                if (age == null || age.trim().isEmpty()) {
                    insertStatement.setNull(2, java.sql.Types.INTEGER);
                } else {
                    insertStatement.setInt(2, Integer.parseInt(age));
                }

                insertStatement.setString(3, gender);
                insertStatement.setString(4, phone);
                insertStatement.setString(5, email);
                insertStatement.setString(6, address);
                insertStatement.setString(7, medicalHistory);

                insertStatement.executeUpdate();

                response.sendRedirect(
                        "patients?success=1"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            // If the UNIQUE (phone, patient_name) constraint in
            // the database still catches a rare race-condition
            // duplicate, this redirect handles it gracefully
            // instead of crashing the application.
            response.sendRedirect(
                    "patients.jsp?error=database"
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
    // ESCAPE JSON
    // =========================================================
    private String escapeJson(String value) {

        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n");
    }
}
