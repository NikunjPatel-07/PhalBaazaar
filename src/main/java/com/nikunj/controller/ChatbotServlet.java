package com.nikunj.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import org.json.JSONArray;
import org.json.JSONObject;
import com.nikunj.model.DBConnection;

@WebServlet(name = "ChatbotServlet", urlPatterns = {"/chat"})
public class ChatbotServlet extends HttpServlet {

    private static final String API_URL = "https://api.groq.com/openai/v1/chat/completions";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        
        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");
        PrintWriter out = res.getWriter();

        String apiKey = System.getProperty("GROQ_API_KEY");
        
        if (apiKey == null || apiKey.trim().isEmpty()) {
            out.print("{\"reply\": \"System Error: Tomcat cannot find the GROQ_API_KEY environment variable! Check Render.\"}");
            out.flush();
            return;
        }

        try {
            BufferedReader reader = req.getReader();
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            
            JSONObject requestJson = new JSONObject(sb.toString());
            String userMessage = requestJson.getString("message");

            StringBuilder inventoryContext = new StringBuilder("Current PhalBazar Inventory:\n");
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement("SELECT name, price FROM products");
                 ResultSet rs = ps.executeQuery()) {
                
                while (rs.next()) {
                    inventoryContext.append("- ").append(rs.getString("name"))
                                    .append(" ($").append(rs.getDouble("price")).append(")\n");
                }
            } catch (Exception e) {
                inventoryContext.append("(Inventory data temporarily unavailable)");
                e.printStackTrace();
            }

            JSONArray messages = new JSONArray();
            
            JSONObject systemMessage = new JSONObject();
            systemMessage.put("role", "system");
            
            String strictPrompt = 
                "You are a strict customer support bot for PhalBazar, a fresh produce e-commerce site. " +
                "You ONLY answer questions about the products listed in the context below. " +
                "If a user asks about anything else (coding, general knowledge, other websites), reply exactly with: 'I can only assist you with PhalBazar products.' " +
                "Do NOT make up products. Do NOT make up prices. Be brief.\n\n" +
                "CONTEXT:\n" + inventoryContext.toString();
                
            systemMessage.put("content", strictPrompt);
            messages.put(systemMessage);
            
            // User prompt
            JSONObject promptMessage = new JSONObject();
            promptMessage.put("role", "user");
            promptMessage.put("content", userMessage);
            messages.put(promptMessage);

            JSONObject payload = new JSONObject();
            payload.put("model", "llama3-8b-8192"); 
            payload.put("messages", messages);

            // 3. Send to Groq
            try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
                HttpPost httpPost = new HttpPost(API_URL);
                httpPost.setHeader("Content-Type", "application/json");
                
                // Using the local apiKey variable here!
                httpPost.setHeader("Authorization", "Bearer " + apiKey); 
                
                httpPost.setEntity(new StringEntity(payload.toString(), "UTF-8"));

                try (CloseableHttpResponse response = httpClient.execute(httpPost)) {
                    String jsonResponse = EntityUtils.toString(response.getEntity());
                    JSONObject jsonResponseObj = new JSONObject(jsonResponse);
                    
                    if (jsonResponseObj.has("error")) {
                        String errorMsg = jsonResponseObj.getJSONObject("error").getString("message");
                        out.print("{\"reply\": \"Groq API Error: " + errorMsg + "\"}");
                        return;
                    }

                    String aiText = jsonResponseObj.getJSONArray("choices")
                            .getJSONObject(0)
                            .getJSONObject("message")
                            .getString("content");

                    JSONObject finalResponse = new JSONObject();
                    finalResponse.put("reply", aiText);
                    out.print(finalResponse.toString());
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"reply\": \"Server Error! Check NetBeans output.\"}");
        } finally {
            out.flush();
        }
    }
}