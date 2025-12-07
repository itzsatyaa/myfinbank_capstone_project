package com.myfinbank.customer.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.myfinbank.customer.model.Account;
import com.myfinbank.customer.model.Investment;

@Repository
public interface InvestmentRepository extends JpaRepository<Investment, Long> {
    
    // ✅ CORRECT: Use Account object, NOT Long accountId
    List<Investment> findByAccount(Account account);
}
