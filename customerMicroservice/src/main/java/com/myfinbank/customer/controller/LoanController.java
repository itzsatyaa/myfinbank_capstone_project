package com.myfinbank.customer.controller;

import com.myfinbank.customer.model.Loan;
import com.myfinbank.customer.service.LoanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/loans")
public class LoanController {
    
    @Autowired
    private LoanService loanService;
    
    @PostMapping("/apply")
    public ResponseEntity<Loan> applyForLoan(@RequestParam Long customerId,
                                             @RequestParam String loanType,
                                             @RequestParam Double loanAmount,
                                             @RequestParam Integer tenureMonths) {
        Loan createdLoan = loanService.applyForLoan(customerId, loanType, loanAmount, tenureMonths);
        return ResponseEntity.ok(createdLoan);
    }
    
    @PostMapping("/{loanId}/approve")
    public ResponseEntity<Loan> approveLoan(@PathVariable Long loanId) {
        Loan approvedLoan = loanService.approveLoan(loanId);
        return ResponseEntity.ok(approvedLoan);
    }
    
    @PostMapping("/{loanId}/deny")
    public ResponseEntity<Loan> denyLoan(@PathVariable Long loanId) {
        Loan deniedLoan = loanService.denyLoan(loanId);
        return ResponseEntity.ok(deniedLoan);
    }
    
    @GetMapping
    public ResponseEntity<List<Loan>> findAllLoans() {
        List<Loan> loans = loanService.findAllLoans();
        return ResponseEntity.ok(loans);
    }
    
    @GetMapping("/customer/{customerId}")
    public ResponseEntity<List<Loan>> getCustomerLoans(@PathVariable Long customerId) {
        List<Loan> loans = loanService.getCustomerLoans(customerId);
        return ResponseEntity.ok(loans);
    }
}
