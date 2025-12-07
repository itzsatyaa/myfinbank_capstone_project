package com.myfinbank.admin.dto;


import java.time.LocalDateTime;

public class NotificationDTO {

    private Long id;
    private String recipientEmail;
    private String message;
    private LocalDateTime sentAt;
    private String status; // SENT or FAILED
    private String recipientType; // CUSTOMER or ADMIN

    // Constructors
    public NotificationDTO() {}

    public NotificationDTO(String recipientEmail, String message, String recipientType) {
        this.recipientEmail = recipientEmail;
        this.message = message;
        this.recipientType = recipientType;
        this.sentAt = LocalDateTime.now();
        this.status = "SENT";
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getRecipientEmail() {
        return recipientEmail;
    }

    public void setRecipientEmail(String recipientEmail) {
        this.recipientEmail = recipientEmail;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public LocalDateTime getSentAt() {
        return sentAt;
    }

    public void setSentAt(LocalDateTime sentAt) {
        this.sentAt = sentAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRecipientType() {
        return recipientType;
    }

    public void setRecipientType(String recipientType) {
        this.recipientType = recipientType;
    }
}