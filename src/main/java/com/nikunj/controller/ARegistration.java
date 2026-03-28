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

@WebServlet(name = "ARegistration", urlPatterns = {"/ARegistration"})
public class ARegistration extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        PrintWriter out = res.getWriter();

        String username = req.getParameter("aunm");
        String email = req.getParameter("aeid");
        String password = req.getParameter("apass");
        String cpassword = req.getParameter("acfmpass");

        if ((password = cpassword).length() >= 8) {

            try (Connection con = DBConnection.getConnection()) {
                String q1 = "insert into aregister(unm,email,pass) values(?,?,?)";
                PreparedStatement ps = con.prepareStatement(q1);
                ps.setString(1, username);
                ps.setString(2, email);
                ps.setString(3, password);
                ps.executeUpdate();
                res.sendRedirect("alogin.jsp");

            } catch (Exception e) {
                out.println(e);
            }
        } else {
            res.sendRedirect("AReg.jsp");
        }
    }
}
