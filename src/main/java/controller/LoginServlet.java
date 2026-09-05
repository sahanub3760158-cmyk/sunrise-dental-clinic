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
import jakarta.servlet.http.HttpSession;

import util.DBConnection;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";

        try (Connection connection = DBConnection.getConnection()) {

            if (connection == null) {
                response.sendRedirect("index.jsp?error=database");
                return;
            }

            try (PreparedStatement statement = connection.prepareStatement(sql)) {

                statement.setString(1, username);
                statement.setString(2, password);

                try (ResultSet result = statement.executeQuery()) {

                    if (result.next()) {

                        HttpSession session = request.getSession();

                        session.setAttribute("username", result.getString("username"));
                        session.setAttribute("role", result.getString("role"));

                        response.sendRedirect("dashboard.jsp");

                    } else {

                        response.sendRedirect("index.jsp?error=invalid");
                    }
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect("index.jsp?error=database");
        }
    }
}