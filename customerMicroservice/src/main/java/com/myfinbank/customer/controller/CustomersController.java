package com.myfinbank.customer.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.myfinbank.customer.dto.AccountDTO;
import com.myfinbank.customer.dto.CustomerAccountDTO;
import com.myfinbank.customer.service.CustomersService;

@RestController
@RequestMapping("/api/customers")
public class CustomersController {

    @Autowired
    private CustomersService customerService;

    // Activate a customer by ID
    @PutMapping("/{id}/activate")
    public ResponseEntity<CustomerAccountDTO> activateCustomer(@PathVariable Long id) {
        CustomerAccountDTO activatedCustomer = customerService.activateCustomer(id);
        if (activatedCustomer != null) {
            return new ResponseEntity<>(activatedCustomer, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    // Deactivate a customer by ID
    @PutMapping("/{id}/deactivate")
    public ResponseEntity<CustomerAccountDTO> deactivateCustomer(@PathVariable Long id) {
        CustomerAccountDTO deactivatedCustomer = customerService.deactivateCustomer(id);
        if (deactivatedCustomer != null) {
            return new ResponseEntity<>(deactivatedCustomer, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    // Get all customers
    @GetMapping
    public ResponseEntity<List<CustomerAccountDTO>> getAllCustomers() {
        List<CustomerAccountDTO> customers = customerService.getAllCustomers();
        return new ResponseEntity<>(customers, HttpStatus.OK);
    }
    
 // Endpoint to get all accounts
    @GetMapping("/accounts")
    public ResponseEntity<List<AccountDTO>> getAllAccounts() {
        List<AccountDTO> accounts = customerService.getAllAccounts();
        return ResponseEntity.ok(accounts); // Return the list of accounts in the response
    }

    // Get a customer by ID
    @GetMapping("/{id}")
    public ResponseEntity<CustomerAccountDTO> getCustomerById(@PathVariable Long id) {
        CustomerAccountDTO customer = customerService.getCustomerById(id);
        if (customer != null) {
            return new ResponseEntity<>(customer, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    // Get all accounts for a specific customer
    @GetMapping("/{customerId}/accounts")
    public ResponseEntity<List<AccountDTO>> getAccountsByCustomerId(@PathVariable Long customerId) {
        List<AccountDTO> accounts = customerService.getAccountsByCustomerId(customerId);
        if (accounts != null && !accounts.isEmpty()) {
            return new ResponseEntity<>(accounts, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }
    

    // Create a new account for a specific customer
    @PostMapping("/{customerId}/accounts")
    public ResponseEntity<AccountDTO> createAccount(@PathVariable Long customerId, @RequestBody AccountDTO accountDTO) {
        AccountDTO createdAccount = customerService.createAccount(customerId, accountDTO);
        return new ResponseEntity<>(createdAccount, HttpStatus.CREATED);
    }

    // Update an existing account by ID
    @PutMapping("/accounts/{accountId}")
    public ResponseEntity<AccountDTO> updateAccount(@PathVariable Long accountId, @RequestBody AccountDTO accountDTO) {
        AccountDTO updatedAccount = customerService.updateAccount(accountId, accountDTO);
        if (updatedAccount != null) {
            return new ResponseEntity<>(updatedAccount, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    // Delete an account by ID
    @DeleteMapping("/accounts/{accountId}")
    public ResponseEntity<Void> deleteAccount(@PathVariable Long accountId) {
        boolean isDeleted = customerService.deleteAccount(accountId);
        if (isDeleted) {
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }
}
