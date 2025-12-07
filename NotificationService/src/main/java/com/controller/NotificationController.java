package com.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.models.Notification;
import com.service.NotificationService;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

	@Autowired
	private NotificationService notificationService;

	// Create or Update Notification
	@PostMapping
	public ResponseEntity<Notification> createOrUpdateNotification(@RequestBody Notification notification) {
		Notification savedNotification = notificationService.saveNotification(notification);
		return ResponseEntity.ok(savedNotification);
	}

	// Get Notification by ID
	@GetMapping("/{id}")
	public ResponseEntity<Notification> getNotificationById(@PathVariable Long id) {
		Optional<Notification> notification = notificationService.getNotificationById(id);
		return notification.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
	}

	// Get All Notifications
	@GetMapping
	public ResponseEntity<List<Notification>> getAllNotifications() {
		List<Notification> notifications = notificationService.getAllNotifications();
		return ResponseEntity.ok(notifications);
	}

	// Delete Notification by ID
	@DeleteMapping("/{id}")
	public ResponseEntity<Void> deleteNotificationById(@PathVariable Long id) {
		notificationService.deleteNotificationById(id);
		return ResponseEntity.noContent().build();
	}

}
