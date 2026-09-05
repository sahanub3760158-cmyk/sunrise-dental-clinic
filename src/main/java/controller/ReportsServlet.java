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

@WebServlet("/reports")
public class ReportsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        int totalPatients = 0;
        int totalAppointments = 0;
        int totalBills = 0;
        double totalRevenue = 0.0;
        int pendingPayments = 0;
        int completedAppointments = 0;

        try (Connection connection = DBConnection.getConnection()) {

            if (connection == null) {
                response.sendRedirect("reports.jsp?error=database");
                return;
            }

            // Total Patients
            String patientSql =
                    "SELECT COUNT(*) FROM patients";

            try (PreparedStatement ps =
                         connection.prepareStatement(patientSql);
                 ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    totalPatients = rs.getInt(1);
                }
            }

            // Total Appointments
            String appointmentSql =
                    "SELECT COUNT(*) FROM appointments";

            try (PreparedStatement ps =
                         connection.prepareStatement(appointmentSql);
                 ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    totalAppointments = rs.getInt(1);
                }
            }

            // Completed Appointments
            String completedSql =
                    "SELECT COUNT(*) FROM appointments " +
                    "WHERE status = 'Completed'";

            try (PreparedStatement ps =
                         connection.prepareStatement(completedSql);
                 ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    completedAppointments = rs.getInt(1);
                }
            }

            // Total Bills
            String billSql =
                    "SELECT COUNT(*) FROM billing";

            try (PreparedStatement ps =
                         connection.prepareStatement(billSql);
                 ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    totalBills = rs.getInt(1);
                }
            }

            // Total Revenue
            String revenueSql =
                    "SELECT COALESCE(SUM(amount), 0) FROM billing " +
                    "WHERE payment_status = 'Paid'";

            try (PreparedStatement ps =
                         connection.prepareStatement(revenueSql);
                 ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    totalRevenue = rs.getDouble(1);
                }
            }

            // Pending Payments
            String pendingSql =
                    "SELECT COUNT(*) FROM billing " +
                    "WHERE payment_status = 'Pending'";

            try (PreparedStatement ps =
                         connection.prepareStatement(pendingSql);
                 ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    pendingPayments = rs.getInt(1);
                }
            }

            // Send data to JSP
            request.setAttribute("totalPatients", totalPatients);
            request.setAttribute("totalAppointments", totalAppointments);
            request.setAttribute("totalBills", totalBills);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("pendingPayments", pendingPayments);
            request.setAttribute("completedAppointments",
                                 completedAppointments);

            request.getRequestDispatcher("reports.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect("reports.jsp?error=database");
        }
    }
}