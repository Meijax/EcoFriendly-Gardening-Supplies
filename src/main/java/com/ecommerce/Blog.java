package com.ecommerce;

import java.sql.Timestamp;

public class Blog {
    private int id;
    private String title;
    private String content;
    private String author;
    private Timestamp createdAt;
    private String link;

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
     public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }
}
