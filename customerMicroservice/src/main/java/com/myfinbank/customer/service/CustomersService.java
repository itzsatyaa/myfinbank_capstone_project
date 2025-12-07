package com.myfinbank.customer.service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.stereotype.Service;

import com.myfinbank.customer.dto.AccountDTO;
import com.myfinbank.customer.dto.CustomerAccountDTO;
import com.myfinbank.customer.model.Account;
import com.myfinbank.customer.model.Customer;
import com.myfinbank.customer.repository.AccountRepository;
import com.myfinbank.customer.repository.CustomerRepository;

@Service
@EnableFeignClients

public class CustomersService {

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private AccountRepository accountRepository;

    // ==================== CUSTOMER REGISTRATION ====================

    /**
     * Register a new customer
     */
    public Customer register(Customer customer) {
        // You can add validation logic here
        return customerRepository.save(customer);
    }

    // ==================== CUSTOMER ACTIVATION ====================

    /**
     * Activate a customer
     */
    public CustomerAccountDTO activateCustomer(Long id) {
        Optional<Customer> optionalCustomer = customerRepository.findById(id);
        if (optionalCustomer.isPresent()) {
            Customer customer = optionalCustomer.get();
            customer.setActive(true);
            customerRepository.save(customer);
            return convertToDTO(customer);
        }
        return null;
    }

    /**
     * Deactivate a customer
     */
    public CustomerAccountDTO deactivateCustomer(Long id) {
        Optional<Customer> optionalCustomer = customerRepository.findById(id);
        if (optionalCustomer.isPresent()) {
            Customer customer = optionalCustomer.get();
            customer.setActive(false);
            customerRepository.save(customer);
            return convertToDTO(customer);
        }
        return null;
    }

    // ==================== CUSTOMER RETRIEVAL ====================

    /**
     * Get all customers
     */
    public List<CustomerAccountDTO> getAllCustomers() {
        List<Customer> customers = customerRepository.findAll();
        return customers.stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }

    /**
     * Get a customer by ID
     */
    public CustomerAccountDTO getCustomerById(Long id) {
        Optional<Customer> optionalCustomer = customerRepository.findById(id);
        return optionalCustomer.map(this::convertToDTO).orElse(null);
    }

    /**
     * Get customer with accounts - Alias method for controller compatibility
     * This method is called by CustomerController.dashboard()
     */
    public CustomerAccountDTO getCustomerWithAccounts(Long customerId) {
        return getCustomerById(customerId);
    }

    // ==================== ACCOUNT OPERATIONS ====================

    /**
     * Get all accounts for a specific customer
     */
    public List<AccountDTO> getAccountsByCustomerId(Long customerId) {
        List<Account> accounts = accountRepository.findByCustomer_Id(customerId);
        return accounts.stream()
            .map(this::convertToAccountDTO)
            .collect(Collectors.toList());
    }

    /**
     * Get all accounts
     */
    public List<AccountDTO> getAllAccounts() {
        List<Account> accounts = accountRepository.findAll();
        return accounts.stream()
            .map(this::convertToAccountDTO)
            .collect(Collectors.toList());
    }

    /**
     * Create a new account for a specific customer
     */
    public AccountDTO createAccount(Long customerId, AccountDTO accountDTO) {
        Optional<Customer> optionalCustomer = customerRepository.findById(customerId);
        if (optionalCustomer.isPresent()) {
            Account account = new Account();
            account.setAccountNumber(accountDTO.getAccountNumber());
            account.setBalance(accountDTO.getBalance());
            account.setCustomer(optionalCustomer.get());
            Account savedAccount = accountRepository.save(account);
            return convertToAccountDTO(savedAccount);
        }
        return null;
    }

    /**
     * Update an existing account
     */
    public AccountDTO updateAccount(Long accountId, AccountDTO accountDTO) {
        Optional<Account> optionalAccount = accountRepository.findById(accountId);
        if (optionalAccount.isPresent()) {
            Account account = optionalAccount.get();
            account.setAccountNumber(accountDTO.getAccountNumber());
            account.setBalance(accountDTO.getBalance());
            Account updatedAccount = accountRepository.save(account);
            return convertToAccountDTO(updatedAccount);
        }
        return null;
    }

    /**
     * Delete an account
     */
    public boolean deleteAccount(Long accountId) {
        Optional<Account> optionalAccount = accountRepository.findById(accountId);
        if (optionalAccount.isPresent()) {
            accountRepository.delete(optionalAccount.get());
            return true;
        }
        return false;
    }

    // ==================== PRIVATE HELPER METHODS ====================

    /**
     * Convert Customer entity to CustomerAccountDTO
     */
    private CustomerAccountDTO convertToDTO(Customer customer) {
        List<AccountDTO> accountDTOs = customer.getAccounts().stream()
            .map(this::convertToAccountDTO)
            .collect(Collectors.toList());

        return new CustomerAccountDTO(
            customer.getId(),
            customer.getUsername(),
            customer.getEmail(),
            customer.isActive(),
            accountDTOs
        );
    }

    /**
     * Convert Account entity to AccountDTO
     */
    private AccountDTO convertToAccountDTO(Account account) {
        return new AccountDTO(
            account.getId(),
            account.getAccountNumber(),
            account.getBalance()
        );
    }
}
