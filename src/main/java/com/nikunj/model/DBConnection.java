package com.nikunj.model;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() {
        try {

            String url = System.getenv("DB_URL");
            String user = System.getenv("DB_USER");
            String pass = System.getenv("DB_PASS");

            if (url == null || user == null || pass == null) {
                throw new RuntimeException("ENV VARIABLES NOT SET");
            }

            System.out.println("DB URL: " + url);

            Class.forName("org.postgresql.Driver");

            return DriverManager.getConnection(url, user, pass);

        } catch (Exception e) {
            System.out.println("DATABASE ERROR:");
            e.printStackTrace();
            return null;
        }
    }
}
