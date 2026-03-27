package com.nikunj.controller;

import java.io.File;
import java.sql.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collection;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 40
)
@WebServlet(name = "AddProduct", urlPatterns = {"/AddProduct"})
public class AddProduct extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String name = req.getParameter("name");
        int price = Integer.parseInt(req.getParameter("price"));

        try {
            String url = "jdbc:mysql://localhost:3306/phalbazar";
            String unm = "root";
            String password = "";
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, unm, password);
            con.setAutoCommit(false);

            PreparedStatement ps = con.prepareStatement("INSERT INTO products(name,price) VALUES(?,?)", Statement.RETURN_GENERATED_KEYS);

            ps.setString(1, name);
            ps.setInt(2, price);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            int productId = 0;

            if (rs.next()) {
                productId = rs.getInt(1);
            }

            Collection<Part> parts = req.getParts();

            int imageCount = 0;

            for (Part part : parts) {

                if (part.getName().equals("images") && part.getSize() > 0) {

                    if (imageCount >= 8) {
                        break;
                    }
                    String fileName = System.currentTimeMillis() + "_" + part.getSubmittedFileName();

                    String uploadDir = "E:/phal_uploads/products/";

                    File uploadFolder = new File(uploadDir);
                    if (!uploadFolder.exists()) {
                        uploadFolder.mkdirs();
                    }

                    String uploadPath = uploadDir + fileName;

                    System.out.println("Saving to: " + uploadPath);

                    part.write(uploadPath);
                    part.write(uploadPath);

                    PreparedStatement imgPs = con.prepareStatement("INSERT INTO product_images(product_id,image_path) VALUES(?,?)");

                    imgPs.setInt(1, productId);
                    imgPs.setString(2, fileName);
                    imgPs.executeUpdate();

                    imageCount++;
                }
            }
            con.commit();
            res.sendRedirect("ItemAdded.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error adding product", e);
        }
    }
}
