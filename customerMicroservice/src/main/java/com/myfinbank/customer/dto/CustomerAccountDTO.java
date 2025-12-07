package com.myfinbank.customer.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor

public class CustomerAccountDTO {
    private Long customerId;
    private String username;
    private String email;
    private boolean active;
    private List<AccountDTO> accounts;

    // Constructor
    public CustomerAccountDTO(Long customerId, String username, String email, boolean active, List<AccountDTO> accounts) {
        this.customerId = customerId;
        this.username = username;
        this.email = email;
        this.active = active;
        this.accounts = accounts;
    }
}
