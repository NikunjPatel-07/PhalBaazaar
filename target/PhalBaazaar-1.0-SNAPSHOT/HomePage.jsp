<%@page import="com.nikunj.model.DBConnection"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <title>PhalBazar - Home</title>

        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

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

                    <div class="col-12 col-sm-6 col-md-4 col-lg-3">

                        <div class="card product-card shadow-sm">

                            <div class="owl-carousel">
                                <%
                                    PreparedStatement psImage = con.prepareStatement("SELECT image_path FROM product_images WHERE product_id=?");
                                    psImage.setInt(1, productId);
                                    ResultSet rsImage = psImage.executeQuery();

                                    while (rsImage.next()) {
                                %>
                                <div>
                                    <img class="w-100 product-img" src="<%= rsImage.getString("image_path") %>" alt="Product Image">
                                </div>
                                <% }
                            rsImage.close();
                            psImage.close();%>
                            </div>

                            <div class="card-body text-center">

                                <h5><%= name%></h5>
                                <p class="text-success fw-bold">$<%= price%></p>

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

                <div class="bottom-bar text-center">
                    <button type="submit" class="btn btn-success btn-lg px-5">
                        Add Selected Items & Go to Cart
                    </button>
                </div>

            </form>

        </div>

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
        
        <div id="chatbot-container" style="position: fixed; bottom: 80px; right: 20px; width: 300px; background: white; border-radius: 10px; box-shadow: 0px 5px 15px rgba(0,0,0,0.2); z-index: 1050; display: none; flex-direction: column;">
            <div style="background: #198754; color: white; padding: 10px; border-top-left-radius: 10px; border-top-right-radius: 10px; font-weight: bold; display: flex; justify-content: space-between;">
                <span>PhalBazar AI Assistant</span>
                <span style="cursor: pointer;" onclick="toggleChat()">✖</span>
            </div>
            <div id="chat-history" style="height: 250px; overflow-y: auto; padding: 10px; font-size: 14px; background: #f8f9fa;">
                <p style="margin: 5px 0; padding: 8px; background: #e9ecef; border-radius: 10px; display: inline-block;">Hello! How can I help you find fresh produce today?</p>
            </div>
            <div style="display: flex; padding: 10px; border-top: 1px solid #ddd;">
                <input type="text" id="chat-input" placeholder="Ask about fruits..." style="flex: 1; border: 1px solid #ccc; border-radius: 5px; padding: 5px;" onkeypress="handleKeyPress(event)">
                <button onclick="sendMessage()" style="background: #198754; color: white; border: none; padding: 5px 10px; margin-left: 5px; border-radius: 5px; cursor: pointer;">Send</button>
            </div>
        </div>

        <button onclick="toggleChat()" style="position: fixed; bottom: 20px; right: 20px; background: #198754; color: white; border: none; border-radius: 50px; width: 50px; height: 50px; font-size: 24px; box-shadow: 0px 4px 10px rgba(0,0,0,0.2); z-index: 1050; cursor: pointer;">
            💬
        </button>

        <script>
            function toggleChat() {
                const chat = document.getElementById('chatbot-container');
                chat.style.display = chat.style.display === 'none' || chat.style.display === '' ? 'flex' : 'none';
            }

            function handleKeyPress(e) {
                if (e.key === 'Enter') sendMessage();
            }

            function sendMessage() {
                const input = document.getElementById('chat-input');
                const message = input.value.trim();
                if (!message) return;

                const chatHistory = document.getElementById('chat-history');
                
                // Show user message
                chatHistory.innerHTML += `<div style="text-align: right;"><p style="margin: 5px 0; padding: 8px; background: #198754; color: white; border-radius: 10px; display: inline-block;">${message}</p></div>`;
                input.value = '';
                chatHistory.scrollTop = chatHistory.scrollHeight;

                // Send to Servlet
                fetch('chat', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ message: message })
                })
                .then(response => response.json())
                .then(data => {
                    // Show AI response
                    chatHistory.innerHTML += `<div style="text-align: left;"><p style="margin: 5px 0; padding: 8px; background: #e9ecef; border-radius: 10px; display: inline-block;">${data.reply}</p></div>`;
                    chatHistory.scrollTop = chatHistory.scrollHeight;
                })
                .catch(error => {
                    chatHistory.innerHTML += `<div style="text-align: left;"><p style="margin: 5px 0; padding: 8px; background: #ffcccc; border-radius: 10px; display: inline-block;">Network Error!</p></div>`;
                });
            }
        </script>

    </body>
</html>