package com.nikunj.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ProductImage", urlPatterns = {"/product-image"})
public class ProductImage extends HttpServlet {

    private static final String IMAGE_DIR = "E:/phal_uploads/products/";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fileName = request.getParameter("name");
        
        String path = getServletContext().getRealPath("/" + fileName);
        System.out.println("DEBUG: " + path);
        
        File file = new File(IMAGE_DIR + fileName);

        System.out.println("EXISTS? " + file.exists());

        System.out.println("NAME: " + fileName);
        if (fileName == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        

        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        response.setContentType(getServletContext().getMimeType(file.getName()));
        response.setContentLength((int) file.length());

        FileInputStream in = new FileInputStream(file);
        OutputStream out = response.getOutputStream();

        byte[] buffer = new byte[4096];
        int bytesRead;

        while ((bytesRead = in.read(buffer)) != -1) {
            out.write(buffer, 0, bytesRead);
        }

        in.close();
        out.close();
    }
}
