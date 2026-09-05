package util;

import java.sql.Connection;

public class DBTest {

    public static void main(String[] args) {

        Connection connection = DBConnection.getConnection();

        if (connection != null) {
            System.out.println("SUCCESS: Database connection is working!");

            try {
                connection.close();
            } catch (Exception e) {
                e.printStackTrace();
            }

        } else {
            System.out.println("FAILED: Database connection could not be established.");
        }
    }
}