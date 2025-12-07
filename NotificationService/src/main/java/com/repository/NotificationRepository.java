package com.repository;



import org.springframework.data.jpa.repository.JpaRepository;

import com.models.Notification;



public interface NotificationRepository extends JpaRepository<Notification, Long> {
}
