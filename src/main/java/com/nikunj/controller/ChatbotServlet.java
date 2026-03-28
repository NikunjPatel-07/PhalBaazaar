package com.nikunj.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
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

// FORCED CORRECT IMPORTS:
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet(name = "ChatbotServlet", urlPatterns = {"/chat"})
public class ChatbotServlet extends HttpServlet {

    // Make sure your API key has NO spaces around it!
    private static final String API_KEY = "AIzaSyADZNArv25QRAY1fUVgz7pVf__9f4Ei2Bs"; 
    private static final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" + API_KEY;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        
        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");
        PrintWriter out = res.getWriter();

        try {
            BufferedReader reader = req.getReader();
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            
            JSONObject requestJson = new JSONObject(sb.toString());
            String userMessage = requestJson.getString("message");

            JSONObject part = new JSONObject().put("text", "You are a shopping assistant for PhalBazar. User says: " + userMessage);
            JSONArray parts = new JSONArray().put(part);
            JSONObject content = new JSONObject().put("parts", parts);
            JSONArray contents = new JSONArray().put(content);
            JSONObject payload = new JSONObject().put("contents", contents);

            try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
                HttpPost httpPost = new HttpPost(API_URL);
                httpPost.setHeader("Content-Type", "application/json");
                httpPost.setEntity(new StringEntity(payload.toString(), "UTF-8"));

                try (CloseableHttpResponse response = httpClient.execute(httpPost)) {
                    String jsonResponse = EntityUtils.toString(response.getEntity());
                    
                    // THIS WILL PRINT GOOGLE'S EXACT RESPONSE TO NETBEANS!
                    System.out.println("========== GEMINI API RESPONSE ==========");
                    System.out.println(jsonResponse);
                    System.out.println("=========================================");
                    
                    JSONObject jsonResponseObj = new JSONObject(jsonResponse);
                    
                    // Crash-proof check: Did Google send an error?
                    if (jsonResponseObj.has("error")) {
                        String errorMsg = jsonResponseObj.getJSONObject("error").getString("message");
                        out.print("{\"reply\": \"Google API Error: " + errorMsg + "\"}");
                        return;
                    }

                    // If no error, get the answer
                    String aiText = jsonResponseObj.getJSONArray("candidates")
                            .getJSONObject(0)
                            .getJSONObject("content")
                            .getJSONArray("parts")
                            .getJSONObject(0)
                            .getString("text");

                    JSONObject finalResponse = new JSONObject();
                    finalResponse.put("reply", aiText);
                    out.print(finalResponse.toString());
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"reply\": \"Server Error: Check NetBeans logs!\"}");
        } finally {
            out.flush();
        }
    }
}