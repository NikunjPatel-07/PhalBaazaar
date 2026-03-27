<%-- 
    Document   : AdminHomePage
    Created on : 23 Feb 2026, 10:22:55 pm
    Author     : Nikunj
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home Page</title>
    </head>
    <body>
        <h1>PhalBazar Product Section</h1>
        <form action="AddProduct" method="post" enctype="multipart/form-data">

            Name: <input type="text" name="name"><br>
            Price: <input type="number" name="price"><br>

            Images (max 8):
            <input type="file" name="images" multiple accept="image/*"><br>

            <button type="submit">Add Product</button>

        </form>
    </body>
</html>
