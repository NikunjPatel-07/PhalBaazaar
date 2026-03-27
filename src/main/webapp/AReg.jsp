<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Admin Portal</title>
    </head>
    <body>

        <h1>Admin Registration</h1>

        <!-- Error Message (from Servlet) -->
        <%
            String msg = (String) request.getAttribute("msg");
            if (msg != null) {
        %>
        <p style="color:red;"><%= msg%></p>
        <%
            }
        %>

        <form action="ARegistration" method="post">
            Enter The Username :
            <input type="text" name="aunm" required><br><br>

            Enter The Email-id :
            <input type="email" name="aeid" required><br><br>

            Enter The Password :
            <input type="password" name="apass" required><br><br>

            Enter The Confirm Password :
            <input type="password" name="acfmpass" required><br><br>

            <input type="submit" value="Register">

            <a href="aLogin.jsp">Login</a><br>
        </form>

    </body>
</html>