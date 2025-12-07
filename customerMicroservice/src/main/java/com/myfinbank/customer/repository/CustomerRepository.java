package com.myfinbank.customer.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.myfinbank.customer.dto.CustomerAccountDTO;
import com.myfinbank.customer.model.Customer;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {
    
    Optional<Customer> findByUsername(String username);
    
    Optional<Customer> findById(Long id);
    
    Optional<Customer> findByEmail(String email);
    
    @Query("SELECT new com.myfinbank.customer.dto.CustomerAccountDTO(c.id, c.username, c.email, c.active, a) " +
           "FROM Customer c LEFT JOIN c.accounts a")
    List<CustomerAccountDTO> findAllCustomerAccounts();
}
