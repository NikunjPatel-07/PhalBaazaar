package com.nikunj.model;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.jdbc.Driver");

            return DriverManager.getConnection("jdbc:mysql://localhost:3306/phalbazar","root","" );

        } catch (Exception e) {
            System.out.println("DATABASE ERROR:");
            e.printStackTrace();
            return null;
        }
    }
}
