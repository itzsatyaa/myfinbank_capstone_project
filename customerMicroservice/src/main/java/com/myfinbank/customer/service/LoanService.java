package com.myfinbank.customer.service;

import com.myfinbank.customer.client.NotificationFeignClient;
import com.myfinbank.customer.dto.NotificationDTO;
import com.myfinbank.customer.model.Account;
import com.myfinbank.customer.model.Customer;
import com.myfinbank.customer.model.Loan;
import com.myfinbank.customer.repository.CustomerRepository;
import com.myfinbank.customer.repository.LoanRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class LoanService {
    
    @Autowired
    private LoanRepository loanRepository;
    
    @Autowired
    private CustomerRepository customerRepository;
    
    @Autowired
    private NotificationFeignClient notificationFeignClient;
    
    // Method 1: Apply for loan with Account and amount (for CustomerLoanController)
    public Loan applyForLoan(Account account, Double amount) {
    	Customer customer = customerRepository.findById(account.getCustomerId())
    	        .orElseThrow(() -> new RuntimeException("Customer not found"));

        
        Loan loan = new Loan();
        loan.setCustomerId(customer.getId());
        loan.setCustomerName(customer.getUsername());
        loan.setCustomerEmail(customer.getEmail());
        loan.setLoanType("PERSONAL"); // Default
        loan.setLoanAmount(amount);
        loan.setTenureMonths(12); // Default 12 months
        loan.setStatus("PENDING");
        loan.setAppliedDate(LocalDateTime.now());
        
        Loan savedLoan = loanRepository.save(loan);
        
        // Send notifications
        sendNotificationToAdmin(savedLoan);
        sendLoanApplicationNotification(customer, savedLoan);
        
        return savedLoan;
    }
    
    // Method 2: Apply for loan with full details (for direct controller usage)
    public Loan applyForLoan(Long customerId, String loanType, Double loanAmount, Integer tenureMonths) {
        Customer customer = customerRepository.findById(customerId)
                .orElseThrow(() -> new RuntimeException("Customer not found"));
        
        Loan loan = new Loan();
        loan.setCustomerId(customerId);
        loan.setCustomerName(customer.getUsername());
        loan.setCustomerEmail(customer.getEmail());
        loan.setLoanType(loanType);
        loan.setLoanAmount(loanAmount);
        loan.setTenureMonths(tenureMonths);
        loan.setStatus("PENDING");
        loan.setAppliedDate(LocalDateTime.now());
        
        Loan savedLoan = loanRepository.save(loan);
        
        // Send notifications
        sendNotificationToAdmin(savedLoan);
        sendLoanApplicationNotification(customer, savedLoan);
        
        return savedLoan;
    }
    
    // Approve loan
    public Loan approveLoan(Long loanId) {
        Loan loan = getLoanById(loanId);
        loan.setStatus("APPROVED");
        loan.setInterestRate(8.5); // Default interest rate
        loan.setApprovedDate(LocalDateTime.now());
        loan.setRemarks("Approved by admin");
        
        Loan updatedLoan = loanRepository.save(loan);
        
        // Send approval notification to customer
        sendLoanApprovalNotification(updatedLoan);
        
        return updatedLoan;
    }
    
    // Deny loan
    public Loan denyLoan(Long loanId) {
        Loan loan = getLoanById(loanId);
        loan.setStatus("REJECTED");
        loan.setRemarks("Rejected by admin");
        
        Loan updatedLoan = loanRepository.save(loan);
        
        // Send rejection notification to customer
        sendLoanRejectionNotification(updatedLoan);
        
        return updatedLoan;
    }
    
    // Find all loans
    public List<Loan> findAllLoans() {
        return loanRepository.findAll();
    }
    
    // Get loans by customer
    public List<Loan> getCustomerLoans(Long customerId) {
        return loanRepository.findByCustomerId(customerId);
    }
    
    public List<Loan> getCustomerLoansByEmail(String email) {
        return loanRepository.findByCustomerEmail(email);
    }
    
    public Loan getLoanById(Long loanId) {
        return loanRepository.findById(loanId)
                .orElseThrow(() -> new RuntimeException("Loan not found"));
    }
 // Add this method to LoanService.java
//    public List<Loan> findLoansByAccountId(Long accountId) {
//        // Assuming you have a method in LoanRepository
//        return loanRepository.findByAccountId(accountId);
//    }

    
    // Update loan status (called from admin service)
    public Loan updateLoanStatus(Long loanId, String status, Double interestRate, String remarks) {
        Loan loan = getLoanById(loanId);
        loan.setStatus(status);
        loan.setInterestRate(interestRate);
        loan.setRemarks(remarks);
        if ("APPROVED".equals(status)) {
            loan.setApprovedDate(LocalDateTime.now());
        }
        return loanRepository.save(loan);
    }
    
    // NOTIFICATION METHODS
    
    private void sendNotificationToAdmin(Loan loan) {
        try {
            NotificationDTO notification = new NotificationDTO();
            notification.setRecipientEmail("admin@myfinbank.com");
            notification.setMessage("New loan application from " + loan.getCustomerName() + 
                                  " for ₹" + String.format("%,.2f", loan.getLoanAmount()) + 
                                  " (" + loan.getLoanType() + " loan)");
            notification.setRecipientType("ADMIN");
            notification.setStatus("SENT");
            
            notificationFeignClient.sendNotification(notification);
        } catch (Exception e) {
            System.err.println("Failed to send admin notification: " + e.getMessage());
        }
    }
    
    private void sendLoanApplicationNotification(Customer customer, Loan loan) {
        try {
            NotificationDTO notification = new NotificationDTO();
            notification.setRecipientEmail(customer.getEmail());
            notification.setMessage("Your loan application for ₹" + String.format("%,.2f", loan.getLoanAmount()) + 
                                  " has been submitted successfully. Application ID: #" + loan.getId());
            notification.setRecipientType("CUSTOMER");
            notification.setStatus("SENT");
            
            notificationFeignClient.sendNotification(notification);
        } catch (Exception e) {
            System.err.println("Failed to send customer notification: " + e.getMessage());
        }
    }
    
    private void sendLoanApprovalNotification(Loan loan) {
        try {
            NotificationDTO notification = new NotificationDTO();
            notification.setRecipientEmail(loan.getCustomerEmail());
            notification.setMessage("✅ Congratulations! Your loan #" + loan.getId() + 
                                  " for ₹" + String.format("%,.2f", loan.getLoanAmount()) + 
                                  " has been APPROVED with " + loan.getInterestRate() + "% interest.");
            notification.setRecipientType("CUSTOMER");
            notification.setStatus("SENT");
            
            notificationFeignClient.sendNotification(notification);
        } catch (Exception e) {
            System.err.println("Failed to send approval notification: " + e.getMessage());
        }
    }
    
    private void sendLoanRejectionNotification(Loan loan) {
        try {
            NotificationDTO notification = new NotificationDTO();
            notification.setRecipientEmail(loan.getCustomerEmail());
            notification.setMessage("❌ Your loan application #" + loan.getId() + 
                                  " has been REJECTED. Reason: " + loan.getRemarks());
            notification.setRecipientType("CUSTOMER");
            notification.setStatus("SENT");
            
            notificationFeignClient.sendNotification(notification);
        } catch (Exception e) {
            System.err.println("Failed to send rejection notification: " + e.getMessage());
        }
    }
}
