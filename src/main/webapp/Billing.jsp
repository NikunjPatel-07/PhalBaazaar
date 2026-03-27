<%-- 
    Document   : AddToCart
    Created on : 23 Feb 2026, 10:22:50 am
    Author     : Nikunj
--%>

<%@page import="com.nikunj.model.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>

<h1>Your Cart</h1>

<table border="1">
    <tr>
        <th>Item</th>
        <th>Price</th>
        <th>Qty</th>
        <th>Total</th>
        <th>Action</th>
    </tr>

    <%
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        int grandTotal = 0;

        if (cart != null) {
            for (CartItem item : cart) {
                grandTotal += item.getTotal();
    %>

    <tr>
        <td><%= item.getName()%></td>
        <td>$<%= item.getPrice()%></td>
        <td><%= item.getQuantity()%></td>
        <td>$<%= item.getTotal()%></td>
        <td>
            <form action="UpdateCart" method="post">
                <input type="hidden" name="pname" value="<%= item.getName()%>">

                <input type="number" 
                       name="quantity" 
                       value="<%= item.getQuantity()%>" 
                       min="0" 
                       style="width:60px;">

                <button type="submit">Update</button>
            </form>
        </td>
    </tr>

    <%
            }
        }
    %>

</table>

<h2>Grand Total: $<%= grandTotal%></h2>

<a href="HomePage.jsp">Continue Shopping</a>