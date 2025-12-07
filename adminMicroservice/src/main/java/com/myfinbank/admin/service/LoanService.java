package com.myfinbank.admin.service;

import com.myfinbank.admin.client.NotificationFeignClient;
import com.myfinbank.admin.dto.LoanDTO;
import com.myfinbank.admin.dto.NotificationDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Arrays;
import java.util.List;

@Service
public class LoanService {
    
    private static final String CUSTOMER_SERVICE_URL = "http://localhost:9090/api/customer";
    
    @Autowired
    private RestTemplate restTemplate;
    
    @Autowired
    private NotificationFeignClient notificationFeignClient;
    
    public List<LoanDTO> getAllLoans() {
        ResponseEntity<LoanDTO[]> response = restTemplate.getForEntity(
                CUSTOMER_SERVICE_URL + "/loans/all", LoanDTO[].class);
        return Arrays.asList(response.getBody());
    }
    
    public LoanDTO getLoanById(Long id) {
        return restTemplate.getForObject(
                CUSTOMER_SERVICE_URL + "/loans/" + id, LoanDTO.class);
    }
    
    public LoanDTO approveLoan(Long loanId, Double interestRate, String remarks) {
        LoanDTO loan = getLoanById(loanId);
        
        // Update loan status via customer service
        String url = CUSTOMER_SERVICE_URL + "/loans/" + loanId + "/approve" +
                    "?interestRate=" + interestRate + "&remarks=" + (remarks != null ? remarks : "Approved");
        
        LoanDTO updatedLoan = restTemplate.postForObject(url, null, LoanDTO.class);
        
        // Send notification to customer
        sendLoanApprovalNotification(updatedLoan, interestRate);
        
        return updatedLoan;
    }
    
    public LoanDTO rejectLoan(Long loanId, String remarks) {
        LoanDTO loan = getLoanById(loanId);
        
        // Update loan status via customer service
        String url = CUSTOMER_SERVICE_URL + "/loans/" + loanId + "/reject" +
                    "?remarks=" + (remarks != null ? remarks : "Rejected");
        
        LoanDTO updatedLoan = restTemplate.postForObject(url, null, LoanDTO.class);
        
        // Send notification to customer
        sendLoanRejectionNotification(updatedLoan, remarks);
        
        return updatedLoan;
    }
    
    private void sendLoanApprovalNotification(LoanDTO loan, Double interestRate) {
        try {
            NotificationDTO notification = new NotificationDTO();
            notification.setRecipientEmail(loan.getCustomerEmail());
            notification.setMessage("Congratulations! Your loan application #" + loan.getId() + 
                                  " for ₹" + String.format("%,.2f", loan.getLoanAmount()) + 
                                  " has been APPROVED with " + interestRate + "% interest rate.");
            notification.setRecipientType("CUSTOMER");
            notification.setStatus("SENT");
            
            notificationFeignClient.sendNotification(notification);
        } catch (Exception e) {
            System.err.println("Failed to send approval notification: " + e.getMessage());
        }
    }
    
    private void sendLoanRejectionNotification(LoanDTO loan, String remarks) {
        try {
            NotificationDTO notification = new NotificationDTO();
            notification.setRecipientEmail(loan.getCustomerEmail());
            notification.setMessage("We regret to inform you that your loan application #" + loan.getId() + 
                                  " for ₹" + String.format("%,.2f", loan.getLoanAmount()) + 
                                  " has been REJECTED. Reason: " + remarks);
            notification.setRecipientType("CUSTOMER");
            notification.setStatus("SENT");
            
            notificationFeignClient.sendNotification(notification);
        } catch (Exception e) {
            System.err.println("Failed to send rejection notification: " + e.getMessage());
        }
    }
}
