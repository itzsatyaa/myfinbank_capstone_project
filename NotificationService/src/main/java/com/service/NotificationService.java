package com.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.models.Account;
import com.models.Notification;
import com.models.Notification.RecipientType;
import com.repository.NotificationRepository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class NotificationService {

    @Autowired
    private NotificationRepository notificationRepository;
    
    
    public void sendNotification(String message, String recipientEmail, RecipientType recipientType) {
        try {
            // Code to send email (or other forms of notification)

            // After sending, save the notification in the database
            Notification notification = new Notification(
                    recipientEmail,
                    message,
                    LocalDateTime.now(),
                    Notification.NotificationStatus.SENT,
                    recipientType
            );
            notificationRepository.save(notification);
        } catch (Exception e) {
            // Handle the exception and possibly log it
            Notification notification = new Notification(
                    recipientEmail,
                    message,
                    LocalDateTime.now(),
                    Notification.NotificationStatus.FAILED,
                    recipientType
            );
            notificationRepository.save(notification);
        }
    }

    public void notifyAdminIfBalanceZero(Account account) {
        if (account.getBalance().compareTo(BigDecimal.ZERO) == 0) {
            String message = "Account with ID " + account.getId() + " has reached a zero balance.";
            sendNotification(message, "iamprakashsatya707@gmail.com", RecipientType.ADMIN);
        }
    }
    
    // Create or Update Notification
    public Notification saveNotification(Notification notification) {
        return notificationRepository.save(notification);
    }

    // Get Notification by ID
    public Optional<Notification> getNotificationById(Long id) {
        return notificationRepository.findById(id);
    }

    // Get All Notifications
    public List<Notification> getAllNotifications() {
        return notificationRepository.findAll();
    }

    // Delete Notification by ID
    public void deleteNotificationById(Long id) {
        notificationRepository.deleteById(id);
    }
    
    
}
