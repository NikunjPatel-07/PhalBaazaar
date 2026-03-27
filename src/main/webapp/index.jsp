<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Registration Page</title>

        <!-- IMPORTANT: Mobile responsiveness -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>

    <body class="bg-light d-flex align-items-center min-vh-100">

        <div class="container">

            <div class="row justify-content-center">

                <!-- Responsive column -->
                <div class="col-12 col-sm-10 col-md-8 col-lg-5">

                    <div class="card shadow-lg border-0 rounded-4 p-3 p-md-4">

                        <h2 class="text-center text-danger mb-3 mb-md-4">
                            Welcome To PhalBazar
                        </h2>

                        <!-- Message from Servlet -->
                        <%
                            String msg = (String) request.getAttribute("msg");
                            if (msg != null) {
                        %>
                        <div class="alert alert-success text-center small">
                            <%= msg%>
                        </div>
                        <%
                            }
                        %>

                        <form action="register" method="post">

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Username</label>
                                <input type="text" name="cunm" class="form-control form-control-lg" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Email</label>
                                <input type="email" name="ceid" class="form-control form-control-lg" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Password</label>
                                <input type="password" name="cpass" class="form-control form-control-lg" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Confirm Password</label>
                                <input type="password" name="cfmpass" class="form-control form-control-lg" required>
                            </div>

                            <button type="submit" class="btn btn-primary btn-lg w-100 mt-2">
                                Register
                            </button>

                        </form>

                        <div class="text-center mt-3 small">
                            <a href="login.jsp" class="d-block mb-1">Already have an account? Login</a>
                            <a href="AReg.jsp">Admin Registration</a>
                        </div>

                    </div>

                </div>
            </div>
        </div>

    </body>
</html>