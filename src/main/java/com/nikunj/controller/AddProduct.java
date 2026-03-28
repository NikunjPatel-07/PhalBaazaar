package com.nikunj.controller;

import com.nikunj.model.DBConnection;

import java.sql.*;
import java.io.IOException;
import java.util.Collection;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

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

        Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", System.getenv("CLOUD_NAME"),
                "api_key", System.getenv("API_KEY"),
                "api_secret", System.getenv("API_SECRET")
        ));

        try (Connection con = DBConnection.getConnection()) {

            if (con == null) {
                throw new RuntimeException("DB CONNECTION FAILED");
            }

            con.setAutoCommit(false);

            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO products(name,price) VALUES(?,?)",
                    Statement.RETURN_GENERATED_KEYS
            );

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

                if ("images".equals(part.getName()) && part.getSize() > 0) {

                    if (imageCount >= 8) {
                        break;
                    }

                    java.io.File tempFile = java.io.File.createTempFile("upload_", ".jpg");
                    tempFile.deleteOnExit();

                    try (java.io.InputStream inputStream = part.getInputStream()) {
                        java.nio.file.Files.copy(
                                inputStream,
                                tempFile.toPath(),
                                java.nio.file.StandardCopyOption.REPLACE_EXISTING
                        );
                    }

                    Map uploadResult = cloudinary.uploader().upload(
                            tempFile,
                            ObjectUtils.emptyMap()
                    );

                    tempFile.delete();

                    String imageUrl = (String) uploadResult.get("secure_url");

                    System.out.println("Uploaded to Cloudinary: " + imageUrl);

                    PreparedStatement imgPs = con.prepareStatement(
                            "INSERT INTO product_images(product_id,image_path) VALUES(?,?)"
                    );

                    imgPs.setInt(1, productId);
                    imgPs.setString(2, imageUrl);
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
