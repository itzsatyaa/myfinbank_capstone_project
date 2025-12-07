package com.myfinbank.customer.model;


import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "investments")
@Data
public class Investment {

	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "account_id", nullable = false)
    private Account account;

    @Column(nullable = false)
    private String investmentType; // LOAN, RD, FD

    @Column(nullable = false)
    private double amount;

    @Column(nullable = false)
    private LocalDateTime investmentDate;

    
    //Constructor
	public Investment() {
        this.investmentDate = LocalDateTime.now();
	}

}
