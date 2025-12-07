package com.myfinbank.customer.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AccountDTO {
    private Long id;
    private String accountNumber;
    private Double balance;
    private String accountType;

    // Custom 3-parameter constructor
    public AccountDTO(Long id, String accountNumber, Double balance) {
        this.id = id;
        this.accountNumber = accountNumber;
        this.balance = balance;
        // accountType will be null, set it explicitly if needed
    }
}
