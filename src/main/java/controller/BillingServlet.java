package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import util.DBConnection;

@WebServlet("/billing")
public class BillingServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =====================================================
    // GET
    // =====================================================

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // =================================================
        // GET PATIENT - AJAX JSON
        // =================================================

        if ("getPatient".equals(action)) {

            getPatient(request, response);
            return;
        }

        // =================================================
        // GET APPOINTMENT - AJAX JSON
        // =================================================

        if ("getAppointment".equals(action)) {

            getAppointment(request, response);
            return;
        }

        // =================================================
        // DELETE BILL
        // =================================================

        if ("delete".equals(action)) {

            deleteBill(request, response);
            return;
        }

        // =================================================
        // DISPLAY BILLING PAGE
        // =================================================

        displayBills(request, response);
    }


    // =====================================================
    // GET PATIENT
    // =====================================================

    private void getPatient(HttpServletRequest request,
                            HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String id = request.getParameter("id");

        if (id == null || id.trim().isEmpty()) {

            response.getWriter().print(
                "{\"success\":false,\"message\":\"Patient ID is required.\"}"
            );

            return;
        }

        String sql =
            "SELECT patient_id, patient_name, phone, email " +
            "FROM patients " +
            "WHERE patient_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            statement.setInt(1, Integer.parseInt(id));

            try (ResultSet rs = statement.executeQuery()) {

                if (rs.next()) {

                    String patientName =
                        jsonEscape(rs.getString("patient_name"));

                    String phone =
                        jsonEscape(rs.getString("phone"));

                    String email =
                        jsonEscape(rs.getString("email"));

                    String json =
                        "{"
                        + "\"success\":true,"
                        + "\"patient\":{"
                        + "\"patient_id\":"
                        + rs.getInt("patient_id")
                        + ","
                        + "\"patient_name\":\""
                        + patientName
                        + "\","
                        + "\"phone\":\""
                        + phone
                        + "\","
                        + "\"email\":\""
                        + email
                        + "\""
                        + "}"
                        + "}";

                    response.getWriter().print(json);

                } else {

                    response.getWriter().print(
                        "{\"success\":false,\"message\":\"Patient not found.\"}"
                    );
                }
            }

        } catch (NumberFormatException e) {

            response.getWriter().print(
                "{\"success\":false,\"message\":\"Invalid Patient ID.\"}"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().print(
                "{\"success\":false,\"message\":\"Database error while loading patient.\"}"
            );
        }
    }


    // =====================================================
    // GET APPOINTMENT
    // =====================================================

    private void getAppointment(HttpServletRequest request,
                                HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String id = request.getParameter("id");

        if (id == null || id.trim().isEmpty()) {

            response.getWriter().print(
                "{\"success\":false,\"message\":\"Appointment ID is required.\"}"
            );

            return;
        }

        String sql =
            "SELECT appointment_id, patient_id, patient_name, " +
            "appointment_date, appointment_time, dentist, status, notes " +
            "FROM appointments " +
            "WHERE appointment_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            statement.setInt(1, Integer.parseInt(id));

            try (ResultSet rs = statement.executeQuery()) {

                if (rs.next()) {

                    String patientName =
                        jsonEscape(rs.getString("patient_name"));

                    String dentist =
                        jsonEscape(rs.getString("dentist"));

                    String status =
                        jsonEscape(rs.getString("status"));

                    String notes =
                        jsonEscape(rs.getString("notes"));

                    String json =
                        "{"
                        + "\"success\":true,"
                        + "\"appointment\":{"
                        + "\"appointment_id\":"
                        + rs.getInt("appointment_id")
                        + ","
                        + "\"patient_id\":"
                        + rs.getInt("patient_id")
                        + ","
                        + "\"patient_name\":\""
                        + patientName
                        + "\","
                        + "\"appointment_date\":\""
                        + rs.getString("appointment_date")
                        + "\","
                        + "\"appointment_time\":\""
                        + rs.getString("appointment_time")
                        + "\","
                        + "\"dentist\":\""
                        + dentist
                        + "\","
                        + "\"status\":\""
                        + status
                        + "\","
                        + "\"notes\":\""
                        + notes
                        + "\""
                        + "}"
                        + "}";

                    response.getWriter().print(json);

                } else {

                    response.getWriter().print(
                        "{\"success\":false,\"message\":\"Appointment not found.\"}"
                    );
                }
            }

        } catch (NumberFormatException e) {

            response.getWriter().print(
                "{\"success\":false,\"message\":\"Invalid Appointment ID.\"}"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().print(
                "{\"success\":false,\"message\":\"Database error while loading appointment.\"}"
            );
        }
    }


    // =====================================================
    // DISPLAY ALL BILLS
    // =====================================================

    private void displayBills(HttpServletRequest request,
                              HttpServletResponse response)
            throws ServletException, IOException {

        String sql =
            "SELECT * FROM billing " +
            "ORDER BY bill_id DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                 connection.prepareStatement(sql);
             ResultSet result = statement.executeQuery()) {

            request.setAttribute("bills", result);

            request.getRequestDispatcher("billing.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "billing.jsp?error=database"
            );
        }
    }


    // =====================================================
    // POST - CREATE BILL
    // =====================================================

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String patientId =
            request.getParameter("patient_id");

        String patientName =
            request.getParameter("patient_name");

        String appointmentId =
            request.getParameter("appointment_id");

        String treatment =
            request.getParameter("treatment");

        String amount =
            request.getParameter("amount");

        String paymentMethod =
            request.getParameter("payment_method");

        String paymentStatus =
            request.getParameter("payment_status");

        String notes =
            request.getParameter("notes");


        // =================================================
        // BASIC VALIDATION
        // =================================================

        if (patientId == null ||
            patientId.trim().isEmpty()) {

            response.sendRedirect(
                "billing.jsp?error=patient"
            );

            return;
        }

        if (patientName == null ||
            patientName.trim().isEmpty()) {

            response.sendRedirect(
                "billing.jsp?error=patient"
            );

            return;
        }

        if (treatment == null ||
            treatment.trim().isEmpty()) {

            response.sendRedirect(
                "billing.jsp?error=treatment"
            );

            return;
        }

        if (amount == null ||
            amount.trim().isEmpty()) {

            response.sendRedirect(
                "billing.jsp?error=amount"
            );

            return;
        }


        // =================================================
        // SQL
        // =================================================

        String sql =
            "INSERT INTO billing " +
            "(patient_id, patient_name, appointment_id, " +
            "treatment, amount, payment_method, " +
            "payment_status, notes) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";


        try (Connection connection =
                 DBConnection.getConnection();
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {


            // Patient ID

            statement.setInt(
                1,
                Integer.parseInt(patientId)
            );


            // Patient Name

            statement.setString(
                2,
                patientName
            );


            // Appointment ID

            if (appointmentId == null ||
                appointmentId.trim().isEmpty()) {

                statement.setNull(
                    3,
                    java.sql.Types.INTEGER
                );

            } else {

                statement.setInt(
                    3,
                    Integer.parseInt(appointmentId)
                );
            }


            // Treatment

            statement.setString(
                4,
                treatment
            );


            // Amount

            statement.setBigDecimal(
                5,
                new java.math.BigDecimal(amount)
            );


            // Payment Method

            statement.setString(
                6,
                paymentMethod
            );


            // Payment Status

            statement.setString(
                7,
                paymentStatus
            );


            // Notes

            statement.setString(
                8,
                notes
            );


            statement.executeUpdate();


            // Success

            response.sendRedirect(
                "billing?success=added"
            );


        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "billing.jsp?error=database"
            );
        }
    }


    // =====================================================
    // DELETE BILL
    // =====================================================

    private void deleteBill(HttpServletRequest request,
                            HttpServletResponse response)
            throws IOException {

        String id =
            request.getParameter("id");


        if (id == null ||
            id.trim().isEmpty()) {

            response.sendRedirect(
                "billing.jsp?error=delete"
            );

            return;
        }


        String sql =
            "DELETE FROM billing WHERE bill_id = ?";


        try (Connection connection =
                 DBConnection.getConnection();
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {


            statement.setInt(
                1,
                Integer.parseInt(id)
            );


            int rows =
                statement.executeUpdate();


            if (rows > 0) {

                response.sendRedirect(
                    "billing?success=deleted"
                );

            } else {

                response.sendRedirect(
                    "billing.jsp?error=delete"
                );
            }


        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "billing.jsp?error=delete"
            );
        }
    }


    // =====================================================
    // JSON ESCAPE
    // =====================================================

    private String jsonEscape(String value) {

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