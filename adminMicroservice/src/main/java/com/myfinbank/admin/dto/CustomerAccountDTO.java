package com.myfinbank.admin.dto;

import java.util.List;

import lombok.Data;

@Data
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
