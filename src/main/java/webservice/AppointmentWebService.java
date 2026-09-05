package webservice;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.DBConnection;

@WebServlet("/api/appointment")
public class AppointmentWebService extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");
        String idParam = request.getParameter("appointmentId");

        if (action == null || idParam == null) {
            out.print("{\"error\":\"Missing 'action' or 'appointmentId' parameter\"}");
            return;
        }

        int appointmentId;
        try {
            appointmentId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            out.print("{\"error\":\"appointmentId must be a number\"}");
            return;
        }

        if ("details".equalsIgnoreCase(action)) {
            out.print(getAppointmentDetailsJson(appointmentId));
        } else if ("bill".equalsIgnoreCase(action)) {
            out.print(getBillJson(appointmentId));
        } else {
            out.print("{\"error\":\"Invalid action. Use 'details' or 'bill'\"}");
        }
    }

    private String getAppointmentDetailsJson(int appointmentId) {
        String sql = "SELECT a.appointment_id, a.patient_name, p.address, p.phone, " +
                     "a.dentist, a.appointment_date, a.appointment_time, a.status " +
                     "FROM appointments a LEFT JOIN patients p ON a.patient_id = p.patient_id " +
                     "WHERE a.appointment_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return String.format(
                    "{\"appointmentId\":%d,\"patientName\":\"%s\",\"address\":\"%s\"," +
                    "\"phone\":\"%s\",\"dentist\":\"%s\",\"date\":\"%s\",\"time\":\"%s\",\"status\":\"%s\"}",
                    rs.getInt("appointment_id"),
                    rs.getString("patient_name"),
                    rs.getString("address"),
                    rs.getString("phone"),
                    rs.getString("dentist"),
                    rs.getDate("appointment_date"),
                    rs.getTime("appointment_time"),
                    rs.getString("status")
                );
            } else {
                return "{\"error\":\"No appointment found for ID " + appointmentId + "\"}";
            }

        } catch (SQLException e) {
            return "{\"error\":\"" + e.getMessage() + "\"}";
        }
    }

    private String getBillJson(int appointmentId) {
        String sql = "SELECT bill_id, treatment, amount, payment_status FROM billing WHERE appointment_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return String.format(
                    "{\"billId\":%d,\"appointmentId\":%d,\"treatment\":\"%s\",\"amount\":%.2f,\"paymentStatus\":\"%s\"}",
                    rs.getInt("bill_id"),
                    appointmentId,
                    rs.getString("treatment"),
                    rs.getDouble("amount"),
                    rs.getString("payment_status")
                );
            } else {
                return "{\"error\":\"No billing record found for appointment ID " + appointmentId + "\"}";
            }

        } catch (SQLException e) {
            return "{\"error\":\"" + e.getMessage() + "\"}";
        }
    }
}