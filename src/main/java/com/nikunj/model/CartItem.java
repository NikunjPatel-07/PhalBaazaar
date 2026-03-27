package com.nikunj.model;

public class CartItem {

    private int productId;
    private String pname;
    private double price;
    private int quantity;

    public CartItem(int productId, String pname, double price, int quantity) {
        this.productId = productId;
        this.pname = pname;
        this.price = price;
        this.quantity = quantity;
    }

    public int getProductId() {
        return productId;
    }

    public String getName() {
        return pname;
    }

    public double getPrice() {
        return price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getTotal() {
        return price * quantity;
    }
}