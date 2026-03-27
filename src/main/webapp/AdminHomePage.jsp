<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Admin - Add Product</title>

        <!-- Mobile responsive -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>

    <body class="bg-light">

        <div class="container py-4 py-md-5">

            <div class="row justify-content-center">

                <div class="col-12 col-md-10 col-lg-6">

                    <div class="card shadow-lg border-0 rounded-4 p-3 p-md-4">

                        <h2 class="text-center text-primary mb-4">
                            Add Product (Admin Panel)
                        </h2>

                        <!-- Message (optional) -->
                        <%
                            String msg = (String) request.getAttribute("msg");
                            if (msg != null) {
                        %>
                        <div class="alert alert-info text-center small">
                            <%= msg%>
                        </div>
                        <%
                            }
                        %>

                        <form action="AddProduct" method="post" enctype="multipart/form-data">

                            <!-- Product Name -->
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Product Name</label>
                                <input type="text" name="name" class="form-control form-control-lg" required>
                            </div>

                            <!-- Product Price -->
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Price</label>
                                <input type="number" name="price" class="form-control form-control-lg" required>
                            </div>

                            <!-- Image Upload -->
                            <div class="mb-3">
                                <label class="form-label fw-semibold">
                                    Upload Images (Max 8)
                                </label>
                                <input type="file" name="images" class="form-control" multiple accept="image/*">
                                <div class="form-text">
                                    You can upload multiple images for carousel display.
                                </div>
                            </div>

                            <!-- Submit -->
                            <button type="submit" class="btn btn-success btn-lg w-100">
                                Add Product
                            </button>

                        </form>

                        <!-- Navigation -->
                        <div class="text-center mt-3 small">
                            <a href="AdminHomePage.jsp">Refresh Page</a><br>
                            <a href="index.jsp">Go to User Page</a>
                        </div>

                    </div>

                </div>

            </div>

        </div>

    </body>
</html>