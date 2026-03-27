<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Login Page</title>
</head>
<body>

    <h1>Login Page</h1>

    <!-- Error Message from Servlet -->
    <%
        String msg = (String) request.getAttribute("msg");
        if (msg != null) {
    %>
        <p style="color:red;"><%= msg %></p>
    <%
        }
    %>

    <form action="login" method="post">
        Enter Email-Id :
        <input type="email" name="email" required><br><br>

        Enter Password :
        <input type="password" name="pass" required><br><br>

        <input type="submit" value="Login">
    </form>

</body>
</html>