package com.myfinbank.admin.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.myfinbank.admin.model.Admin;

public interface AdminRepository extends JpaRepository<Admin, Long> {
	Optional<Admin> findById(Long id);
	 Optional<Admin> findByUsername(String username);
	 boolean existsByUsername(String username);
}
