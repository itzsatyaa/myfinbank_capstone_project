package com.myfinbank.admin.dto;

import lombok.Data;

@Data
public class AccountDTO {
    private Long id;
    private String accountNumber;
    private Double balance;
 
    public AccountDTO(){
    	
    }
    // Constructor
    public AccountDTO(Long id, String accountNumber, Double balance) {
        this.id = id;
        this.accountNumber = accountNumber;
        this.balance = balance;
    }
}
