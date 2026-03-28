<%@page import="com.nikunj.model.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Your Cart</title>

        <!-- Mobile responsive -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>

    <body class="bg-light">

        <div class="container py-4">

            <h2 class="mb-4 text-center">🛒 Your Cart</h2>

            <%
                List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
                int grandTotal = 0;
            %>

            <!-- EMPTY CART -->
            <%
                if (cart == null || cart.isEmpty()) {
            %>
            <div class="alert alert-warning text-center">
                Your cart is empty.
            </div>

            <div class="text-center">
                <a href="HomePage.jsp" class="btn btn-primary">Start Shopping</a>
            </div>
            <%
            } else {
            %>

            <!-- CART TABLE -->
            <div class="table-responsive">
                <table class="table table-bordered table-hover align-middle text-center">

                    <thead class="table-dark">
                        <tr>
                            <th>Item</th>
                            <th>Price</th>
                            <th>Qty</th>
                            <th>Total</th>
                            <th>Update</th>
                        </tr>
                    </thead>

                    <tbody>
                        <%
                            for (CartItem item : cart) {
                                grandTotal += item.getTotal();
                        %>

                        <tr>
                            <td><%= item.getName()%></td>
                            <td>$<%= item.getPrice()%></td>
                            <td><%= item.getQuantity()%></td>
                            <td>$<%= item.getTotal()%></td>

                            <td>
                                <form action="UpdateCart" method="post" class="d-flex justify-content-center gap-2">

                                    <input type="hidden" name="pname" value="<%= item.getName()%>">

                                    <input type="number"
                                           name="quantity"
                                           value="<%= item.getQuantity()%>"
                                           min="0"
                                           class="form-control"
                                           style="width:80px;">

                                    <button type="submit" class="btn btn-sm btn-success">
                                        Update
                                    </button>
                                </form>
                            </td>
                        </tr>

                        <%
                            }
                        %>
                    </tbody>

                </table>
            </div>

            <!-- TOTAL -->
            <div class="d-flex justify-content-between align-items-center mt-4">

                <h4>Total: <span class="text-success">$<%= grandTotal%></span></h4>

                <div>
                    <a href="HomePage.jsp" class="btn btn-outline-primary">
                        Continue Shopping
                    </a>

                    <a href="#" class="btn btn-success">
                        Checkout
                    </a>
                </div>

            </div>

            <%
                }
            %>

        </div>

    </body>
</html>