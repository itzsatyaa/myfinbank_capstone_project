package com.myfinbank.admin.client;

import java.util.List;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;

import com.myfinbank.admin.dto.AccountDTO;
import com.myfinbank.admin.dto.CustomerAccountDTO;

@FeignClient(name = "CUSTOMERMICROSERVICE", url = "http://localhost:9090/api/customers")
public interface CustomerFeignClient {

    // Activate a customer
    @PutMapping("/{id}/activate")
    ResponseEntity<CustomerAccountDTO> activateCustomer(@PathVariable("id") Long id);

    // Deactivate a customer
    @PutMapping("/{id}/deactivate")
    ResponseEntity<CustomerAccountDTO> deactivateCustomer(@PathVariable("id") Long id);

    // Get all customers
    @GetMapping
    ResponseEntity<List<CustomerAccountDTO>> getAllCustomers();

    // Get a customer by ID
    @GetMapping("/{id}")
    ResponseEntity<CustomerAccountDTO> getCustomerById(@PathVariable("id") Long id);

    
    
    // Get all accounts for a specific customer
    @GetMapping("/{customerId}/accounts")
    ResponseEntity<List<AccountDTO>> getAccountsByCustomerId(@PathVariable("customerId") Long customerId);

    @GetMapping("/accounts")
    List<AccountDTO> getAllAccounts();
    
    // Create a new account for a specific customer
    @PostMapping("/{customerId}/accounts")
    ResponseEntity<AccountDTO> createAccount(@PathVariable("customerId") Long customerId, @RequestBody AccountDTO accountDTO);

    // Update an existing account
    @PutMapping("/accounts/{accountId}")
    ResponseEntity<AccountDTO> updateAccount(@PathVariable("accountId") Long accountId, @RequestBody AccountDTO accountDTO);

    // Delete an account
    @DeleteMapping("/accounts/{accountId}")
    ResponseEntity<Void> deleteAccount(@PathVariable("accountId") Long accountId);
}
