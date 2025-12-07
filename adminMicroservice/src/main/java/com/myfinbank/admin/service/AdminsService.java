package com.myfinbank.admin.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.myfinbank.admin.client.CustomerFeignClient;
import com.myfinbank.admin.client.NotificationFeignClient;
import com.myfinbank.admin.dto.AccountDTO;
import com.myfinbank.admin.dto.CustomerAccountDTO;
import com.myfinbank.admin.dto.NotificationDTO;

@Service
public class AdminsService {

    @Autowired
    private CustomerFeignClient customerFeignClient;

    @Autowired
    private NotificationFeignClient notificationFeignClient;

    // Customer Management with Notifications

    public CustomerAccountDTO activateCustomer(Long id) {
        ResponseEntity<CustomerAccountDTO> response = customerFeignClient.activateCustomer(id);
        CustomerAccountDTO customer = response.getBody();

        // Send notification to customer
        if (customer != null && customer.getEmail() != null) {
            try {
                NotificationDTO notification = new NotificationDTO(
                    customer.getEmail(),
                    "Dear " + customer.getUsername() + ", your account has been successfully activated. Welcome to MyFinBank!",
                    "CUSTOMER"
                );
                notificationFeignClient.sendNotification(notification);
            } catch (Exception e) {
                // Log notification failure but don't fail the main operation
                System.err.println("Failed to send activation notification: " + e.getMessage());
            }
        }

        return customer;
    }

    public CustomerAccountDTO deactivateCustomer(Long id) {
        ResponseEntity<CustomerAccountDTO> response = customerFeignClient.deactivateCustomer(id);
        CustomerAccountDTO customer = response.getBody();

        // Send notification to customer
        if (customer != null && customer.getEmail() != null) {
            try {
                NotificationDTO notification = new NotificationDTO(
                    customer.getEmail(),
                    "Dear " + customer.getUsername() + ", your account has been deactivated. Please contact support for more information.",
                    "CUSTOMER"
                );
                notificationFeignClient.sendNotification(notification);
            } catch (Exception e) {
                // Log notification failure but don't fail the main operation
                System.err.println("Failed to send deactivation notification: " + e.getMessage());
            }
        }

        return customer;
    }

    public List<CustomerAccountDTO> getAllCustomers() {
        ResponseEntity<List<CustomerAccountDTO>> response = customerFeignClient.getAllCustomers();
        return response.getBody();
    }

    public CustomerAccountDTO getCustomerById(Long id) {
        ResponseEntity<CustomerAccountDTO> response = customerFeignClient.getCustomerById(id);
        return response.getBody();
    }

    public List<AccountDTO> getAccountsByCustomerId(Long customerId) {
        ResponseEntity<List<AccountDTO>> response = customerFeignClient.getAccountsByCustomerId(customerId);
        return response.getBody();
    }

    // Account Management with Notifications

    public List<AccountDTO> getAllAccounts() {
        return customerFeignClient.getAllAccounts();
    }

    public AccountDTO createAccount(Long customerId, AccountDTO accountDTO) {
        ResponseEntity<AccountDTO> response = customerFeignClient.createAccount(customerId, accountDTO);
        AccountDTO account = response.getBody();

        // Get customer details to send notification
        CustomerAccountDTO customer = getCustomerById(customerId);

        if (customer != null && customer.getEmail() != null && account != null) {
            try {
                // Send notification to customer
                NotificationDTO notification = new NotificationDTO(
                    customer.getEmail(),
                    "Dear " + customer.getUsername() + ", your new bank account has been created successfully. Account Number: " + account.getAccountNumber() + ". Current Balance: $" + account.getBalance(),
                    "CUSTOMER"
                );
                notificationFeignClient.sendNotification(notification);

                // Notify admin as well
                NotificationDTO adminNotification = new NotificationDTO(
                    "admin@myfinbank.com",
                    "New account created for customer " + customer.getUsername() + " (Customer ID: " + customerId + "). Account Number: " + account.getAccountNumber(),
                    "ADMIN"
                );
                notificationFeignClient.sendNotification(adminNotification);
            } catch (Exception e) {
                // Log notification failure but don't fail the main operation
                System.err.println("Failed to send account creation notification: " + e.getMessage());
            }
        }

        return account;
    }

    public AccountDTO updateAccount(Long accountId, AccountDTO accountDTO) {
        ResponseEntity<AccountDTO> response = customerFeignClient.updateAccount(accountId, accountDTO);
        AccountDTO account = response.getBody();

        if (account != null) {
            try {
                // Notify admin about account update
                NotificationDTO adminNotification = new NotificationDTO(
                    "admin@myfinbank.com",
                    "Account updated - Account ID: " + accountId + ", Account Number: " + account.getAccountNumber() + ", New Balance: $" + account.getBalance(),
                    "ADMIN"
                );
                notificationFeignClient.sendNotification(adminNotification);
            } catch (Exception e) {
                // Log notification failure but don't fail the main operation
                System.err.println("Failed to send account update notification: " + e.getMessage());
            }
        }

        return account;
    }

    public boolean deleteAccount(Long accountId) {
        ResponseEntity<Void> response = customerFeignClient.deleteAccount(accountId);
        boolean success = response.getStatusCode().is2xxSuccessful();

        if (success) {
            try {
                // Notify admin about account deletion
                NotificationDTO adminNotification = new NotificationDTO(
                    "admin@myfinbank.com",
                    "Account deleted - Account ID: " + accountId,
                    "ADMIN"
                );
                notificationFeignClient.sendNotification(adminNotification);
            } catch (Exception e) {
                // Log notification failure but don't fail the main operation
                System.err.println("Failed to send account deletion notification: " + e.getMessage());
            }
        }

        return success;
    }
}
