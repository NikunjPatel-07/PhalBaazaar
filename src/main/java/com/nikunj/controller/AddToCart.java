package com.nikunj.controller;

import com.nikunj.model.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AddToCart", urlPatterns = {"/addtocart"})
public class AddToCart extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        int totalItems = Integer.parseInt(req.getParameter("totalItems"));

        try (Connection con = DBConnection.getConnection()) {
            for (int i = 0; i < totalItems; i++) {
                String qParam = req.getParameter("quantity_" + i);
                int qty = (qParam != null) ? Integer.parseInt(qParam) : 0;

                if (qty > 0) {
                    int pid = Integer.parseInt(req.getParameter("productId_" + i));

                    // Fetch product details from DB
                    PreparedStatement ps = con.prepareStatement("SELECT name, price FROM products WHERE id = ?");
                    ps.setInt(1, pid);
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
                        String name = rs.getString("name");
                        double price = rs.getDouble("price");

                        // Check if already in cart to update qty, else add new
                        boolean exists = false;
                        for (CartItem item : cart) {
                            if (item.getProductId() == pid) {
                                item.setQuantity(item.getQuantity() + qty);
                                exists = true;
                                break;
                            }
                        }
                        if (!exists) {
                            cart.add(new CartItem(pid, name, price, qty));
                        }
                    }
                    rs.close();
                    ps.close();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        session.setAttribute("cart", cart);
        res.sendRedirect("Billing.jsp");
    }   
}
