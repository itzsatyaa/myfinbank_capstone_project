package com.myfinbank.customer.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.myfinbank.customer.client.NotificationFeignClient;
import com.myfinbank.customer.dto.AccountDTO;
import com.myfinbank.customer.dto.CustomerAccountDTO;
import com.myfinbank.customer.dto.NotificationDTO;
import com.myfinbank.customer.model.Account;
import com.myfinbank.customer.model.Customer;
import com.myfinbank.customer.model.Loan;
import com.myfinbank.customer.model.Transaction;
import com.myfinbank.customer.repository.CustomerRepository;
import com.myfinbank.customer.service.AccountService;
import com.myfinbank.customer.service.CustomerService;
import com.myfinbank.customer.service.LoanService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/api/customer")
@CrossOrigin(origins = "http://localhost:58837")
public class CustomerController {

    @Autowired
    private AccountService accountService;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private NotificationFeignClient notificationFeignClient;
    
    @Autowired
    private LoanService loanService;
    
    @Autowired
    private PasswordEncoder passwordEncoder;

    // ==================== AUTHENTICATION ====================

    // Customer Registration
    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("customer", new Customer());
        return "customer-register";
    }

    @PostMapping("/register")
    public String registerCustomer(@ModelAttribute Customer customer, Model model) {
        customerService.register(customer);
        model.addAttribute("successMessage", "Customer registered successfully!");
        return "redirect:/api/customer/login";
    }

    // Customer Login
    @GetMapping("/login")
    public String login() {
        return "customer-login";
    }

    @PostMapping("/login")
    public String login(@ModelAttribute Customer customer, HttpSession session, Model model) {
        // Fetch the customer from the database
        Customer authenticatedCustomer = customerRepository.findByUsername(customer.getUsername())
            .orElse(null);

        // Check if the customer exists and the password matches
        if (authenticatedCustomer != null && 
                passwordEncoder.matches(customer.getPassword(), authenticatedCustomer.getPassword())) {  // ← FIXED
                
                // Set customer in session
                session.setAttribute("customerId", authenticatedCustomer.getId());
                session.setAttribute("customerEmail", authenticatedCustomer.getEmail());
                return "redirect:/api/customer/dashboard";
            } else {
                model.addAttribute("error", "Invalid username or password.");
                return "customer-login";
            }
        }

 // ==================== DASHBOARD WITH NOTIFICATIONS ====================
    @GetMapping("/dashboard")
    public String showDashboard(Model model, HttpSession session) {
        // Get customer ID from session
        Long customerId = (Long) session.getAttribute("customerId");
        if (customerId == null) {
            return "redirect:/api/customer/login";
        }

        // Get customer details with accounts
        CustomerAccountDTO customer = customerService.getCustomerWithAccounts(customerId);
        if (customer == null) {
            model.addAttribute("error", "Customer not found");
            return "redirect:/api/customer/login";
        }

        model.addAttribute("customer", customer);
        
        // ✅ NEW: Add account object to model for JSP access
        if (customer.getAccounts() != null && !customer.getAccounts().isEmpty()) {
            // Get the first account (or you can modify logic to get primary account)
            AccountDTO firstAccount = customer.getAccounts().get(0);
            
            // Create a simple Account object for JSP
            Account account = new Account();
            account.setId(firstAccount.getId());
            account.setAccountNumber(firstAccount.getAccountNumber());
            account.setAccountType(firstAccount.getAccountType());
            account.setBalance(firstAccount.getBalance());
            
            model.addAttribute("account", account);
        }

        // Get notifications for this customer
        try {
            ResponseEntity<List<NotificationDTO>> response =
                    notificationFeignClient.getAllNotifications();
            if (response.getBody() != null) {
                // Filter notifications for this customer's email and type CUSTOMER
                List<NotificationDTO> customerNotifications = response.getBody().stream()
                        .filter(n -> n.getRecipientEmail() != null && n.getRecipientEmail().equals(customer.getEmail()))
                        .filter(n -> "CUSTOMER".equals(n.getRecipientType()))
                        .sorted((n1, n2) -> {
                            if (n1.getSentAt() != null && n2.getSentAt() != null) {
                                return n2.getSentAt().compareTo(n1.getSentAt()); // Latest first
                            }
                            return 0;
                        })
                        .collect(Collectors.toList());
                model.addAttribute("notifications", customerNotifications);
                System.out.println("Loaded " + customerNotifications.size() + " notifications for customer");
            } else {
                model.addAttribute("notifications", new ArrayList<>());
            }
        } catch (Exception e) {
            // If notification service is down, just show empty notifications
            model.addAttribute("notifications", new ArrayList<>());
            System.err.println("Failed to fetch notifications: " + e.getMessage());
        }

        return "customer-dashboard";
    }


    // Customer Logout
    @PostMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/api/customer/login";
    }

    // ==================== ACCOUNT OPERATIONS ====================

    // Get all accounts list
    @GetMapping("/accounts")
    public String getAllAccounts(Model model) {
        List<Account> accounts = accountService.findAll();
        model.addAttribute("accounts", accounts);
        return "accountList";
    }

    // Deposit Funds
    @GetMapping("/deposit")
    public String showDepositForm() {
        return "deposit";
    }

    @PostMapping("/deposit")
    public String deposit(@RequestParam Long accountId, @RequestParam Double amount, Model model) {
        Account account = accountService.findAccountById(accountId)
            .orElseThrow(() -> new RuntimeException("Account not found"));

        if (account != null) {
            accountService.deposit(account, amount);
            model.addAttribute("account", account);
            model.addAttribute("message", "Deposit successful!");
        } else {
            model.addAttribute("message", "Account not found.");
        }

        return "redirect:/api/customer/deposit";
    }

    // Withdraw Funds
    @GetMapping("/withdraw")
    public String showWithdrawForm() {
        return "withdraw";
    }

    @PostMapping("/withdraw")
    public String withdraw(@RequestParam Long accountId, @RequestParam Double amount, Model model) {
        Account account = accountService.findAccountById(accountId)
            .orElseThrow(() -> new RuntimeException("Account not found"));

        if (accountService.withdraw(account, amount) != null) {
            model.addAttribute("message", "Withdrawal successful!");
        } else {
            model.addAttribute("error", "Insufficient funds!");
        }

        return "redirect:/api/customer/withdraw";
    }

    // Transfer Funds
    @GetMapping("/transfer")
    public String showTransferForm() {
        return "transfer";
    }

    @PostMapping("/transfer")
    public String transfer(@RequestParam Long fromAccountId, @RequestParam Long toAccountId,
                          @RequestParam Double amount, Model model) {
        Account fromAccount = accountService.findAccountById(fromAccountId)
            .orElseThrow(() -> new RuntimeException("From Account not found"));
        Account toAccount = accountService.findAccountById(toAccountId)
            .orElseThrow(() -> new RuntimeException("To Account not found"));

        if (accountService.transfer(fromAccount, toAccount, amount) != null) {
            model.addAttribute("message", "Transfer successful!");
        } else {
            model.addAttribute("error", "Transfer failed! Check balance and account IDs.");
        }

        return "redirect:/api/customer/transfer";
    }
    @GetMapping("/calculate-emi")
    public String showEmiCalculator() {
        return "calculate-emi"; // returns calculate-emi.jsp
    }
    
    

 // ==================== TRANSACTION HISTORY ====================

    @GetMapping("/transactions")
    public String showTransactions(Model model, HttpSession session) {
        Long customerId = (Long) session.getAttribute("customerId");
        if (customerId == null) {
            return "redirect:/api/customer/login";
        }

        try {
            // Get customer's accounts
            CustomerAccountDTO customer = customerService.getCustomerWithAccounts(customerId);
            
            if (customer == null || customer.getAccounts() == null || customer.getAccounts().isEmpty()) {
                model.addAttribute("message", "No accounts found.");
                model.addAttribute("transactions", new ArrayList<>());
                model.addAttribute("accountId", "N/A");  
                return "view-transactions";
            }

            // Collect transactions from all customer accounts
            List<Transaction> allTransactions = new ArrayList<>();
            for (AccountDTO account : customer.getAccounts()) {
                List<Transaction> txns = accountService.getTransactionsHistory(account.getId());
                if (txns != null) {
                    allTransactions.addAll(txns);
                }
            }

            // Sort by date (most recent first)
            allTransactions.sort((t1, t2) -> {
                if (t1.getDate() != null && t2.getDate() != null) {
                    return t2.getDate().compareTo(t1.getDate());
                }
                return 0;
            });

            model.addAttribute("transactions", allTransactions);
            model.addAttribute("customer", customer);
            model.addAttribute("accountId", "All Accounts");  // ✅ ADD THIS
            
        } catch (Exception e) {
            model.addAttribute("error", "Failed to load transactions: " + e.getMessage());
            model.addAttribute("transactions", new ArrayList<>());
            model.addAttribute("accountId", "Error");  // ✅ ADD THIS
        }
        
        return "view-transactions";
    }
    
 // ==================== CUSTOMER SUPPORT ====================
    @GetMapping("/support")
    public String showCustomerSupport(HttpSession session, Model model) {
        // Check if customer is logged in
        Long customerId = (Long) session.getAttribute("customerId");
        if (customerId == null) {
            return "redirect:/api/customer/login";
        }
        
        return "customer-support";
    }


 // ==================== LOAN APPLICATION ====================

 // Show loan application form
 @GetMapping("/apply-loan")
 public String showLoanApplicationForm(Model model, HttpSession session) {
     Long customerId = (Long) session.getAttribute("customerId");
     if (customerId == null) {
         return "redirect:/api/customer/login";
     }
     return "apply-loan";
 }

 // Submit loan application
 @PostMapping("/apply-loan")
 public String applyForLoan(@RequestParam String loanType,
                           @RequestParam Double loanAmount,
                           @RequestParam Integer tenureMonths,
                           HttpSession session,
                           Model model) {
     Long customerId = (Long) session.getAttribute("customerId");
     if (customerId == null) {
         return "redirect:/api/customer/login";
     }
     
     try {
         loanService.applyForLoan(customerId, loanType, loanAmount, tenureMonths);
         model.addAttribute("successMessage", "Loan application submitted successfully!");
         return "redirect:/api/customer/loan-status";
     } catch (Exception e) {
         model.addAttribute("errorMessage", "Failed to submit loan application: " + e.getMessage());
         return "apply-loan";
     }
 }

 // View loan status
 @GetMapping("/loan-status")
 public String viewLoanStatus(Model model, HttpSession session) {
     Long customerId = (Long) session.getAttribute("customerId");
     if (customerId == null) {
         return "redirect:/api/customer/login";
     }
     
     List<Loan> loans = loanService.getCustomerLoans(customerId);
     model.addAttribute("loans", loans);
     return "loan-status";
 }
//REST API for admin to get all loans
@GetMapping("/loans/all")
@ResponseBody
public ResponseEntity<List<Loan>> getAllLoansForAdmin() {
	List<Loan> loans = loanService.findAllLoans();
  return ResponseEntity.ok(loans);
}
@GetMapping("/loans/{id}")
@ResponseBody
public ResponseEntity<Loan> getLoanById(@PathVariable Long id) {
    Loan loan = loanService.getLoanById(id);
    return loan != null ? ResponseEntity.ok(loan) : ResponseEntity.notFound().build();
}


//REST API for admin to approve loan
@PostMapping("/loans/{id}/approve")
@ResponseBody
public ResponseEntity<Loan> approveLoanFromAdmin(@PathVariable Long id,
                                               @RequestParam Double interestRate,
                                               @RequestParam String remarks) {
  Loan loan = loanService.updateLoanStatus(id, "APPROVED", interestRate, remarks);
  
  // Send notification to customer
  sendLoanStatusNotification(loan, "APPROVED");
  
  return ResponseEntity.ok(loan);
}

//REST API for admin to reject loan
@PostMapping("/loans/{id}/reject")
@ResponseBody
public ResponseEntity<Loan> rejectLoanFromAdmin(@PathVariable Long id,
                                              @RequestParam String remarks) {
  Loan loan = loanService.updateLoanStatus(id, "REJECTED", null, remarks);
  
  // Send notification to customer
  sendLoanStatusNotification(loan, "REJECTED");
  
  return ResponseEntity.ok(loan);
}

private void sendLoanStatusNotification(Loan loan, String status) {
  try {
      NotificationDTO notification = new NotificationDTO();
      notification.setRecipientEmail(loan.getCustomerEmail());
      
      if ("APPROVED".equals(status)) {
          notification.setMessage("✅ Congratulations! Your loan #" + loan.getId() + 
                                " for ₹" + String.format("%,.2f", loan.getLoanAmount()) + 
                                " has been APPROVED with " + loan.getInterestRate() + "% interest.");
      } else {
          notification.setMessage("❌ Your loan application #" + loan.getId() + 
                                " has been REJECTED. Reason: " + loan.getRemarks());
      }
      
      notification.setRecipientType("CUSTOMER");
      notification.setStatus("SENT");
      
      notificationFeignClient.sendNotification(notification);
  } catch (Exception e) {
      System.err.println("Failed to send notification: " + e.getMessage());
  }
}

}
