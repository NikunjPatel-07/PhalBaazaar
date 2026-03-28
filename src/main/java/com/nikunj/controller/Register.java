package com.nikunj.controller;

import com.nikunj.model.DBConnection;
import java.sql.*;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "Register", urlPatterns = {"/register"})
public class Register extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        PrintWriter out = res.getWriter();

        String username = req.getParameter("cunm");
        String email = req.getParameter("ceid");
        String password = req.getParameter("cpass");
        String cpassword = req.getParameter("cfmpass");

        if ((password = cpassword).length() >= 8) {

            try (Connection con = DBConnection.getConnection()) {
                String q1 = "insert into register(unm,email,pass) values(?,?,?)";
                PreparedStatement ps = con.prepareStatement(q1);
                ps.setString(1, username);
                ps.setString(2, email);
                ps.setString(3, password);
                ps.executeUpdate();
                res.sendRedirect("login.jsp");

            } catch (Exception e) {
                out.println(e);
            }
        } else{
            res.sendRedirect("index.html");
            
        }

    }
}
