<%@page import="com.nikunj.model.DBConnection"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <title>PhalBazar - Home</title>

        <!-- Mobile -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Owl Carousel -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css">

        <style>
            .product-card {
                border-radius: 15px;
                overflow: hidden;
                transition: transform 0.2s;
            }

            .product-card:hover {
                transform: translateY(-5px);
            }

            .product-img {
                height: 200px;
                object-fit: cover;
            }

            .quantity-box button {
                width: 35px;
            }

            .bottom-bar {
                position: fixed;
                bottom: 0;
                width: 100%;
                background: white;
                padding: 15px;
                box-shadow: 0 -3px 10px rgba(0,0,0,0.1);
                z-index: 1000;
            }
        </style>
    </head>

    <body class="bg-light">

        <div class="container py-4">

            <h2 class="text-center text-success mb-4">PhalBazar Products</h2>

            <form action="addtocart" method="post">

                <div class="row g-4">

                    <%
                        Connection con = null;
                        int i = 0;
                        try {
                            con = DBConnection.getConnection();
                            PreparedStatement psProduct = con.prepareStatement("SELECT * FROM products");
                            ResultSet rsProduct = psProduct.executeQuery();

                            while (rsProduct.next()) {
                                int productId = rsProduct.getInt("id");
                                String name = rsProduct.getString("name");
                                double price = rsProduct.getDouble("price");
                    %>

                    <!-- PRODUCT CARD -->
                    <div class="col-12 col-sm-6 col-md-4 col-lg-3">

                        <div class="card product-card shadow-sm">

                            <!-- CAROUSEL -->
                            <div class="owl-carousel">
                                <%
                                    PreparedStatement psImage = con.prepareStatement("SELECT image_path FROM product_images WHERE product_id=?");
                                    psImage.setInt(1, productId);
                                    ResultSet rsImage = psImage.executeQuery();

                                    while (rsImage.next()) {
                                %>
                                <div>
                                    <img class="w-100 product-img"
                                         src="<%= request.getContextPath()%>/product-image?name=<%= rsImage.getString("image_path")%>">
                                </div>
                                <% }
                            rsImage.close();
                            psImage.close();%>
                            </div>

                            <div class="card-body text-center">

                                <h5><%= name%></h5>
                                <p class="text-success fw-bold">$<%= price%></p>

                                <!-- QUANTITY -->
                                <div class="d-flex justify-content-center align-items-center gap-2 mb-2">

                                    <button type="button" class="btn btn-outline-secondary btn-sm" onclick="decrease(this)">-</button>

                                    <input type="text"
                                           name="quantity_<%= i%>"
                                           value="0"
                                           class="form-control text-center"
                                           style="width:60px;" readonly>

                                    <button type="button" class="btn btn-outline-secondary btn-sm" onclick="increase(this)">+</button>

                                </div>

                                <input type="hidden" name="productId_<%= i%>" value="<%= productId%>">

                            </div>

                        </div>

                    </div>

                    <%
                                i++;
                            }
                        } catch (Exception e) {
                            out.println(e.getMessage());
                        } finally {
                            if (con != null) {
                                con.close();
                            }
                        }
                    %>

                </div>

                <input type="hidden" name="totalItems" value="<%= i%>">

                <!-- BOTTOM BAR -->
                <div class="bottom-bar text-center">
                    <button type="submit" class="btn btn-success btn-lg px-5">
                        Add Selected Items & Go to Cart
                    </button>
                </div>

            </form>

        </div>

        <!-- JS -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js"></script>

        <script>
                                        $(document).ready(function () {
                                            $('.owl-carousel').owlCarousel({
                                                items: 1,
                                                loop: true,
                                                dots: true,
                                                autoplay: true
                                            });
                                        });

                                        function increase(btn) {
                                            let input = btn.parentElement.querySelector("input");
                                            input.value = parseInt(input.value) + 1;
                                        }

                                        function decrease(btn) {
                                            let input = btn.parentElement.querySelector("input");
                                            let val = parseInt(input.value);
                                            if (val > 0)
                                                input.value = val - 1;
                                        }
        </script>

    </body>
</html>