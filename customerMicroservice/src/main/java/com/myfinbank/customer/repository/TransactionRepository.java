package com.myfinbank.customer.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.myfinbank.customer.model.Account;
import com.myfinbank.customer.model.Transaction;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Long> {
    
    // ✅ Find by Account object (works with @ManyToOne)
    List<Transaction> findByAccount(Account account);
    
    // ✅ Find by Account sorted by date (newest first)
    List<Transaction> findByAccountOrderByDateDesc(Account account);
}
