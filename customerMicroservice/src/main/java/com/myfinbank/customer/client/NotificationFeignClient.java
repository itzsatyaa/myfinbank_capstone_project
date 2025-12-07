package com.myfinbank.customer.client;

import java.util.List;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import com.myfinbank.customer.dto.NotificationDTO;

@FeignClient(name = "notification-service", url = "http://localhost:9093")
public interface NotificationFeignClient {
    
    
    @PostMapping("/api/notifications")
    ResponseEntity<NotificationDTO> sendNotification(@RequestBody NotificationDTO notification);
    
    @GetMapping("/api/notifications")
    ResponseEntity<List<NotificationDTO>> getAllNotifications();
    
    @GetMapping("/api/notifications/{id}")
    ResponseEntity<NotificationDTO> getNotificationById(@PathVariable Long id);
}
