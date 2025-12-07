package com.myfinbank.customer.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.myfinbank.customer.model.Account;
import com.myfinbank.customer.model.Transaction;
import com.myfinbank.customer.repository.AccountRepository;
import com.myfinbank.customer.repository.TransactionRepository;

@Service
public class TransactionService {
    
    @Autowired
    private TransactionRepository transactionRepository;
    
    @Autowired
    private AccountRepository accountRepository;
    
    // ✅ FIXED: Accept accountId, fetch Account, then query
    public List<Transaction> getTransactionsByAccountId(Long accountId) {
        Account account = accountRepository.findById(accountId)
                .orElseThrow(() -> new RuntimeException("Account not found"));
        
        return transactionRepository.findByAccount(account);
    }
}
