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

@WebServlet(name = "alogin", urlPatterns = {"/alogin"})
public class alogin extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        PrintWriter out = res.getWriter();
        String email = req.getParameter("email");
        String pass = req.getParameter("pass");

        try (Connection con = DBConnection.getConnection()) {
            String q1 = "select * from aregister where email=? and pass=?";
            PreparedStatement ps = con.prepareStatement(q1);
            ps.setString(1, email);
            ps.setString(2, pass);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                res.sendRedirect("AdminHomePage.jsp");
            } else {
                res.sendRedirect("AReg.html");
            }
        } catch (Exception e) {
            out.println(e);
        }
    }
}
