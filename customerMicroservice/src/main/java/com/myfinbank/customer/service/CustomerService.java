package com.myfinbank.customer.service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.myfinbank.customer.dto.AccountDTO;
import com.myfinbank.customer.dto.CustomerAccountDTO;
import com.myfinbank.customer.exceptions.CustomerAlreadyExistsException;
import com.myfinbank.customer.exceptions.CustomerNotFoundException;
import com.myfinbank.customer.model.Account;
import com.myfinbank.customer.model.Customer;
import com.myfinbank.customer.repository.AccountRepository;
import com.myfinbank.customer.repository.CustomerRepository;

@Service
public class CustomerService {

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // Register new customer
    @Transactional
    public Customer register(Customer customer) {
        
        if (customer.getPassword() == null || customer.getPassword().isBlank()) {
            throw new IllegalArgumentException("Password cannot be empty");
        }

        if (customerRepository.findByUsername(customer.getUsername()).isPresent()) {
            throw new CustomerAlreadyExistsException("Username already exists");
        }

        if (customerRepository.findByEmail(customer.getEmail()).isPresent()) {
            throw new CustomerAlreadyExistsException("Email already exists");
        }

        customer.setPassword(passwordEncoder.encode(customer.getPassword()));
        customer.setActive(true);

        return customerRepository.save(customer);
    }

    // Find customer by username
    public Optional<Customer> findByUsername(String username) {
        return customerRepository.findByUsername(username);
    }

    // Find customer by ID
    public Optional<Customer> findById(Long id) {
        return customerRepository.findById(id);
    }

    // Find customer by email
    public Optional<Customer> findByEmail(String email) {
        return customerRepository.findByEmail(email);
    }

    // Get all customers
    public List<Customer> getAllCustomers() {
        return customerRepository.findAll();
    }

    // Get customer with accounts (Method that was missing)
    public CustomerAccountDTO getCustomerWithAccounts(Long customerId) {
        Customer customer = customerRepository.findById(customerId)
            .orElseThrow(() -> new CustomerNotFoundException("Customer not found with ID: " + customerId));

        List<Account> accounts = accountRepository.findByCustomer_Id(customerId);

        return convertToCustomerAccountDTO(customer, accounts);
    }

    // Update customer
    @Transactional
    public Customer updateCustomer(Long id, Customer customerDetails) {
        Customer customer = customerRepository.findById(id)
            .orElseThrow(() -> new CustomerNotFoundException("Customer not found with ID: " + id));

        if (customerDetails.getEmail() != null) {
            customer.setEmail(customerDetails.getEmail());
        }

        if (customerDetails.getPassword() != null && !customerDetails.getPassword().isBlank()) {
            customer.setPassword(passwordEncoder.encode(customerDetails.getPassword()));
        }

        return customerRepository.save(customer);
    }

    // Delete customer
    @Transactional
    public void deleteCustomer(Long id) {
        Customer customer = customerRepository.findById(id)
            .orElseThrow(() -> new CustomerNotFoundException("Customer not found with ID: " + id));
        
        customerRepository.delete(customer);
    }

 // Helper method to convert to DTO
    private CustomerAccountDTO convertToCustomerAccountDTO(Customer customer, List<Account> accounts) {
        CustomerAccountDTO dto = new CustomerAccountDTO();
        dto.setCustomerId(customer.getId());
        dto.setUsername(customer.getUsername());
        dto.setEmail(customer.getEmail());
        dto.setActive(customer.isActive());
        
        List<AccountDTO> accountDTOs = accounts.stream()
            .map(this::convertToAccountDTO)
            .collect(Collectors.toList());
        
        dto.setAccounts(accountDTOs);
        return dto;
    }

    private AccountDTO convertToAccountDTO(Account account) {
        AccountDTO dto = new AccountDTO();
        dto.setId(account.getId());  // Changed from setAccountId to setId
        dto.setAccountNumber(account.getAccountNumber());
        dto.setAccountType(account.getAccountType());
        dto.setBalance(account.getBalance());
        return dto;
    }

}
