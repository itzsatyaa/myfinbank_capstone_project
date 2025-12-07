package com.myfinbank.customer.service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.myfinbank.customer.model.Account;
import com.myfinbank.customer.model.Customer;
import com.myfinbank.customer.model.Transaction;
import com.myfinbank.customer.repository.AccountRepository;
import com.myfinbank.customer.repository.CustomerRepository;
import com.myfinbank.customer.repository.TransactionRepository;

@Service
public class AccountService {
    
    @Autowired
    private AccountRepository accountRepository;
    
    @Autowired
    private TransactionRepository transactionRepository;
    
    @Autowired
    private CustomerRepository customerRepository;
    
    // Create Account
    public Account createAccount(Account account) {
        Customer customer = customerRepository.findById(account.getCustomer().getId())
                .orElseThrow(() -> new RuntimeException("Customer not found"));
        account.setCustomer(customer);
        return accountRepository.save(account);
    }
    
    // Find Account by ID
    public Optional<Account> findAccountById(Long accountId) {
        return accountRepository.findById(accountId);
    }
    
    // Deposit Method
    public Account deposit(Account account, Double amount) {
        double newBalance = account.getBalance() + amount;
        account.setBalance(newBalance);
        accountRepository.save(account);
        
        // Record transaction
        Transaction transaction = new Transaction();
        transaction.setTransactionId(UUID.randomUUID().toString());
        transaction.setAccount(account); // ✅ Use setAccount()
        transaction.setAmount(amount);
        transaction.setType("DEPOSIT");
        transaction.setBalanceAfter(newBalance);
        transactionRepository.save(transaction);
        
        return account;
    }
    
    // Withdraw Method (ONLY ONE - removed duplicate)
    public Account withdraw(Account account, Double amount) {
        if (account.getBalance() < amount) {
            throw new RuntimeException("Insufficient funds");
        }
        
        double newBalance = account.getBalance() - amount;
        account.setBalance(newBalance);
        accountRepository.save(account);
        
        // Record transaction
        Transaction transaction = new Transaction();
        transaction.setTransactionId(UUID.randomUUID().toString());
        transaction.setAccount(account); // ✅ Use setAccount()
        transaction.setAmount(amount);
        transaction.setType("WITHDRAW");
        transaction.setBalanceAfter(newBalance);
        transactionRepository.save(transaction);
        
        return account;
    }
    
    // Transfer Method
    public Transaction transfer(Account fromAccount, Account toAccount, Double amount) {
        if (fromAccount.getBalance() < amount) {
            throw new RuntimeException("Insufficient funds");
        }
        
        // Deduct from sender
        double newFromBalance = fromAccount.getBalance() - amount;
        fromAccount.setBalance(newFromBalance);
        accountRepository.save(fromAccount);
        
        // Add to receiver
        double newToBalance = toAccount.getBalance() + amount;
        toAccount.setBalance(newToBalance);
        accountRepository.save(toAccount);
        
        // Record transaction for sender
        Transaction transaction = new Transaction();
        transaction.setTransactionId(UUID.randomUUID().toString());
        transaction.setAccount(fromAccount); // ✅ Use setAccount()
        transaction.setAmount(amount);
        transaction.setType("TRANSFER");
        transaction.setBalanceAfter(newFromBalance);
        transactionRepository.save(transaction);
        
        return transaction;
    }
    
    // Get Accounts by Customer ID
    public List<Account> getAccountsByCustomerId(Long customerId) {
        return accountRepository.findByCustomer_Id(customerId);
    }
    
    // ✅ FIXED: Get Transaction History
    public List<Transaction> getTransactionsHistory(Long accountId) {
        // Verify account exists
        Account account = accountRepository.findById(accountId)
                .orElseThrow(() -> new RuntimeException("Account not found with ID: " + accountId));
        
        // ✅ Use findByAccount() since Transaction has @ManyToOne Account
        return transactionRepository.findByAccount(account);
    }
    
    // Find All Accounts
    public List<Account> findAll() {
        return accountRepository.findAll();
    }
    
    // Update Account
    public Account updateAccount(Account account) {
        Optional<Account> existingAccount = accountRepository.findById(account.getId());
        if (existingAccount.isPresent()) {
            account.setAccountNumber(existingAccount.get().getAccountNumber());
            account.setCustomer(existingAccount.get().getCustomer());
            account.setBalance(existingAccount.get().getBalance());
            return accountRepository.save(account);
        } else {
            throw new RuntimeException("Account not found");
        }
    }
    
    // Delete Account
    public void deleteAccount(Long accountId) {
        accountRepository.deleteById(accountId);
    }
}
