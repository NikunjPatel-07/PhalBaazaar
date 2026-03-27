<%@page import="com.nikunj.model.DBConnection"%>
<%@page import="java.sql.*"%>
<%@page import="com.nikunj.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <title>PhalBazar - Home</title>

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css">

        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
                background-color: #f4f4f4;
            }

            h1 { text-align: center; color: #2e7d32; }

            /* --- HORIZONTAL LAYOUT --- */
            .product-container {
                display: flex;         /* Horizontal row */
                flex-wrap: wrap;       /* Move to next line if full */
                justify-content: center; 
                gap: 20px;             /* Space between cards */
                padding: 20px;
                margin-bottom: 100px;  /* Space for fixed button */
            }

            .product {
                border: 1px solid #ddd;
                padding: 15px;
                width: 280px;          /* Width of each card */
                background-color: #fff;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            }

            .product img {
                width: 100%;
                height: 180px;
                object-fit: cover;
                border-radius: 5px;
            }

            .quantity-box {
                display: inline-flex;
                border: 2px solid black;
                border-radius: 6px;
                overflow: hidden;
                margin: 10px 0;
            }

            .quantity-box button {
                width: 30px;
                border: none;
                cursor: pointer;
                background: #eee;
            }

            .quantity-box input {
                width: 40px;
                text-align: center;
                border: none;
                font-weight: bold;
            }

            /* --- FIXED BOTTOM ACTION BAR --- */
            .bottom-bar {
                position: fixed;
                bottom: 0;
                left: 0;
                width: 100%;
                background: white;
                padding: 20px;
                text-align: center;
                box-shadow: 0 -5px 10px rgba(0,0,0,0.1);
                z-index: 1000;
            }

            .bulk-add-btn {
                background-color: #2e7d32;
                color: white;
                border: none;
                padding: 15px 50px;
                border-radius: 5px;
                font-size: 18px;
                font-weight: bold;
                cursor: pointer;
            }
        </style>
    </head>

    <body>

        <h1>PhalBazar Products</h1>

        <form action="addtocart" method="post">
            
            <div class="product-container">

                <%
                    Connection con = null;
                    int i = 0; // Index for different items
                    try {
                        con = DBConnection.getConnection();
                        PreparedStatement psProduct = con.prepareStatement("SELECT * FROM products");
                        ResultSet rsProduct = psProduct.executeQuery();

                        while (rsProduct.next()) {
                            int productId = rsProduct.getInt("id");
                            String name = rsProduct.getString("name");
                            double price = rsProduct.getDouble("price");
                %>

                <div class="product">
                    <div class="owl-carousel">
                        <%
                            PreparedStatement psImage = con.prepareStatement("SELECT image_path FROM product_images WHERE product_id=?");
                            psImage.setInt(1, productId);
                            ResultSet rsImage = psImage.executeQuery();
                            while (rsImage.next()) {
                        %>
                        <div>
                            <img src="<%= request.getContextPath()%>/product-image?name=<%= rsImage.getString("image_path")%>">
                        </div>
                        <% } rsImage.close(); psImage.close(); %>
                    </div>

                    <h3><%= name%></h3>
                    <p style="color:green; font-weight: bold;">$<%= price%></p>

                    <div class="quantity-box">
                        <button type="button" onclick="decrease(this)">-</button>
                        <input type="text" name="quantity_<%= i %>" value="0" readonly>
                        <button type="button" onclick="increase(this)">+</button>
                    </div>

                    <input type="hidden" name="productId_<%= i %>" value="<%= productId%>">

                </div>

                <%
                        i++; // Increment index
                        }
                    } catch (Exception e) { out.println(e.getMessage()); }
                    finally { if (con != null) con.close(); }
                %>

            </div>

            <input type="hidden" name="totalItems" value="<%= i %>">

            <div class="bottom-bar">
                <button type="submit" class="bulk-add-btn">Add Selected Items & Go to Bill</button>
            </div>

        </form>

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js"></script>

        <script>
            $(document).ready(function () {
                $('.owl-carousel').owlCarousel({ items: 1, loop: true, dots: true, autoplay: true });
            });

            function increase(btn) {
                let input = btn.parentElement.querySelector("input");
                input.value = parseInt(input.value) + 1;
            }

            function decrease(btn) {
                let input = btn.parentElement.querySelector("input");
                let val = parseInt(input.value);
                if (val > 0) input.value = val - 1;
            }
        </script>
    </body>
</html>