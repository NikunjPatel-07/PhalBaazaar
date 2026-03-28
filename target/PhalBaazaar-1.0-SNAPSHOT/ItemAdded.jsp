<%@page import="java.sql.*"%>
<%@page import="com.nikunj.model.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Items Added</title>

        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

        <style>
            body {
                background-color: #f8f9fa;
            }

            .success-box {
                max-width: 700px;
                margin: 60px auto;
                background: white;
                padding: 30px;
                border-radius: 15px;
                text-align: center;
                box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            }

            .success-icon {
                font-size: 60px;
                color: #28a745;
            }

            .carousel img {
                height: 300px;
                object-fit: cover;
            }
        </style>
    </head>

    <body>

        <div class="success-box">

            <div class="success-icon mb-3">
                <i class="bi bi-check-circle-fill"></i>
            </div>

            <h3 class="fw-bold">Items Added Successfully!</h3>

            <p class="text-muted">
                Your product and images are now live.
            </p>

            <hr>

            <%
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(
                        "SELECT image_path FROM product_images ORDER BY id DESC LIMIT 5"
                );
                ResultSet rs = ps.executeQuery();

                int count = 0;
            %>

            <% if (rs.next()) { %>

            <!-- 🚀 CAROUSEL -->
            <div id="carouselExample" class="carousel slide" data-bs-ride="carousel">

                <div class="carousel-inner">

                    <%
                        do {
                            String img = rs.getString("image_path");
                    %>

                    <div class="carousel-item <%= (count == 0 ? "active" : "")%>">
                        <img src="<%= img%>" class="d-block w-100">
                    </div>

                    <%
                            count++;
                        } while (rs.next());
                    %>

                </div>

                <button class="carousel-control-prev" type="button" data-bs-target="#carouselExample" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon"></span>
                </button>

                <button class="carousel-control-next" type="button" data-bs-target="#carouselExample" data-bs-slide="next">
                    <span class="carousel-control-next-icon"></span>
                </button>

            </div>

            <% } else { %>

            <p>No images found</p>

            <% }%>

        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    </body>
</html>