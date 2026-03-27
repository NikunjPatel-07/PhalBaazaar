<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Registration Page</title>
    </head>
    <body>

        <h1 style="color: red;">Welcome To PhalBazar</h1>

        <!-- Message from Servlet -->
        <%
            String msg = (String) request.getAttribute("msg");
            if (msg != null) {
        %>
        <p style="color:green;"><%= msg%></p>
        <%
            }
        %>

        <form action="register" method="post">
            Enter The Username :
            <input type="text" name="cunm" required><br><br>

            Enter The Email-id :
            <input type="email" name="ceid" required><br><br>

            Enter The Password :
            <input type="password" name="cpass" required><br><br>

            Enter The Confirm Password :
            <input type="password" name="cfmpass" required><br><br>

            <input type="submit" value="Register">

            <br>
            <a href="login.jsp">Login</a><br>

            For Admin :
            <a href="AReg.jsp">Admin</a>
        </form>

    </body>
</html>