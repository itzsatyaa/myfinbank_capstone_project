package com.myfinbank.customer.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.myfinbank.customer.model.Account;
import com.myfinbank.customer.model.Investment;
import com.myfinbank.customer.model.Loan;
import com.myfinbank.customer.model.Transaction;
import com.myfinbank.customer.service.AccountService;
import com.myfinbank.customer.service.InvestmentService;
import com.myfinbank.customer.service.LoanService;

@RestController
@RequestMapping("/api/transaction")
@CrossOrigin(origins = "http://localhost:58837")
public class TransactionController {

	@Autowired
	private AccountService accountService;

	@Autowired
	private LoanService loanService;
	
	@Autowired
	private InvestmentService investmentService;
	
	
	@PostMapping("/deposit")
    public ResponseEntity<Account> deposit(@RequestParam Long accountId, @RequestParam Double amount) {
        Account account = accountService.findAccountById(accountId)
                .orElseThrow(() -> new RuntimeException("Account not found"));
        Account updatedAccount = accountService.deposit(account, amount);
        return ResponseEntity.status(HttpStatus.OK).body(updatedAccount);
    }

	
    @PostMapping("/withdraw")
    public ResponseEntity<Account> withdraw(@RequestParam long accountId, @RequestParam Double amount) {
        Account account = accountService.findAccountById(accountId)
                .orElseThrow(() -> new RuntimeException("Account not found"));
        Account updatedAccount = accountService.withdraw(account, amount);
        return ResponseEntity.status(HttpStatus.OK).body(updatedAccount);
    }

    @PostMapping("/transfer")
    public ResponseEntity<Transaction> transfer(@RequestParam Long fromAccountId, @RequestParam Long toAccountId,
                                                @RequestParam Double amount) {
        Account fromAccount = accountService.findAccountById(fromAccountId)
                .orElseThrow(() -> new RuntimeException("From Account not found"));
        Account toAccount = accountService.findAccountById(toAccountId)
                .orElseThrow(() -> new RuntimeException("To Account not found"));
        Transaction transaction = accountService.transfer(fromAccount, toAccount, amount);
        return ResponseEntity.status(HttpStatus.OK).body(transaction);
    }
    
    
    @GetMapping("/transactions/{accountId}")
    public ResponseEntity<List<Transaction>> getTransactionHistory(@PathVariable Long accountId) {
        List<Transaction> transactions = accountService.getTransactionsHistory(accountId);
        return ResponseEntity.status(HttpStatus.OK).body(transactions);
    } 
    
    
    @PostMapping("/investments/invest/{accountId}")
    public ResponseEntity<Investment> invest(@PathVariable Long accountId, @RequestParam String investmentType,
                                             @RequestParam double amount) {
        Investment investment = investmentService.invest(accountId, investmentType, amount);
        return ResponseEntity.status(HttpStatus.CREATED).body(investment);
    }
    
    
    @GetMapping("/investments/account/{accountId}")
    public ResponseEntity<List<Investment>> getInvestmentsByAccountId(@PathVariable Long accountId) {
        List<Investment> investments = investmentService.getInvestmentsByAccountId(accountId);
        return ResponseEntity.status(HttpStatus.OK).body(investments);
    }
    
    
    @PostMapping("/applyLoan")
    public ResponseEntity<Loan> applyForLoan(@RequestParam Long accountId, @RequestParam Double amount) {
        Account account = accountService.findAccountById(accountId)
                .orElseThrow(() -> new RuntimeException("Account not found"));
        Loan loan = loanService.applyForLoan(account, amount);
        return ResponseEntity.status(HttpStatus.CREATED).body(loan);
    }


    @GetMapping("/loanStatus/{accountId}")  // ✅ ADD {accountId} to path
    public ResponseEntity<List<Loan>> getLoanStatus(@PathVariable Long accountId) {
        // First get the account to find the customer
        Account account = accountService.findAccountById(accountId)
                .orElseThrow(() -> new RuntimeException("Account not found"));  // ✅ Handle Optional
        
        // Then get loans by customer ID
        List<Loan> loans = loanService.getCustomerLoans(account.getCustomerId());
        
        return ResponseEntity.status(HttpStatus.OK).body(loans);
    }



//	 @PostMapping("/sendMessage")
//	    public Chat sendMessageToAdmin(@RequestParam Long customerId, @RequestParam Long adminId, @RequestParam String message) {
//	        Customer customer = customerService.findByCustomerId(customerId)
//	        		.orElseThrow(() -> new RuntimeException("Customer not found"));
//	        Admin admin = adminService.findById(adminId)
//	        		.orElseThrow(() -> new RuntimeException("Admin not found"));
//	        
//	        return chatService.sendMessage(customer, admin, "CUSTOMER", message);
//	    }
//
//	    // Get chat history between customer and admin
//	    @GetMapping("/chatHistory/{customerId}/{adminId}")
//	    public List<Chat> getChatHistory(@PathVariable Long customerId, @PathVariable Long adminId) {
//	        return chatService.getChatHistory(customerId, adminId);
//	    }
}
