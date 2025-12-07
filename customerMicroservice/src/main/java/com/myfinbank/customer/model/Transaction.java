package com.myfinbank.customer.model;

import java.time.LocalDateTime;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name = "transactions")
@Getter
@Setter
public class Transaction {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String transactionId;
    
    private Double amount;
    
    private String type; // "DEPOSIT", "WITHDRAW", "TRANSFER", "INVESTMENT"
    
    private LocalDateTime date;
    
    private Double balanceAfter; // ✅ ADD THIS
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id", nullable = false)
    @ToString.Exclude
    private Account account;
    
    // Constructor
    public Transaction() {
        this.date = LocalDateTime.now();
    }
    
    // ✅ Helper method for JSP
    public Long getAccountId() {
        return account != null ? account.getId() : null;
    }
}
