package com.nikunj.controller;

import com.nikunj.model.*;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "UpdateCart", urlPatterns = {"/UpdateCart"})
public class UpdateCart extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String name = req.getParameter("pname");
        int qty = Integer.parseInt(req.getParameter("quantity"));

        HttpSession session = req.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart != null) {

            for (CartItem item : cart) {

                if (item.getName().equals(name)) {

                    if (qty <= 0) {
                        cart.remove(item);  // remove if qty = 0
                    } else {
                        item.setQuantity(qty); // update qty
                    }

                    break;
                }
            }
        }

        session.setAttribute("cart", cart);
        res.sendRedirect("Billing.jsp");
    }
}
