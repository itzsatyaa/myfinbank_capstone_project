package com.myfinbank.customer.repository;

import com.myfinbank.customer.model.Account;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AccountRepository extends JpaRepository<Account, Long> {
    
    Optional<Account> findByAccountNumber(String accountNumber);
    
  
    List<Account> findByCustomer_Id(Long customerId);
    
   
}
