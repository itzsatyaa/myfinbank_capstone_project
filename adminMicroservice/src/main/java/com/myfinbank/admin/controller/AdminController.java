package com.myfinbank.admin.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.myfinbank.admin.client.NotificationFeignClient;
import com.myfinbank.admin.dto.AccountDTO;
import com.myfinbank.admin.dto.CustomerAccountDTO;
import com.myfinbank.admin.dto.LoanDTO;
import com.myfinbank.admin.dto.NotificationDTO;
import com.myfinbank.admin.model.Loan;
import com.myfinbank.admin.service.AdminsService;
import com.myfinbank.admin.service.LoanService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/api/admin")
public class AdminController {

    @Autowired
    private AdminsService adminService;

    @Autowired
    private NotificationFeignClient notificationFeignClient;

    @Autowired
    private LoanService loanService;

    // ==================== DASHBOARD WITH NOTIFICATIONS ====================
    @GetMapping("/dashboard")
    public String showDashboard(Model model, HttpSession session) {
        // Get admin email from session
        String adminEmail = (String) session.getAttribute("adminEmail");
        if (adminEmail == null) {
            adminEmail = "iamprakashsatya707@gmail.com"; // Default for testing
        }

        // Fetch notifications for admin
        try {
            ResponseEntity<List<NotificationDTO>> response =
                    notificationFeignClient.getAllNotifications();
            if (response.getBody() != null) {
                // Filter notifications for ADMIN type
                List<NotificationDTO> adminNotifications = response.getBody().stream()
                        .filter(n -> "ADMIN".equals(n.getRecipientType()))
                        .sorted((n1, n2) -> {
                            if (n1.getSentAt() != null && n2.getSentAt() != null) {
                                return n2.getSentAt().compareTo(n1.getSentAt());
                            }
                            return 0;
                        })
                        .collect(Collectors.toList());
                model.addAttribute("notifications", adminNotifications);
            } else {
                model.addAttribute("notifications", new ArrayList<>());
            }
        } catch (Exception e) {
            model.addAttribute("notifications", new ArrayList<>());
            System.err.println("Failed to fetch admin notifications: " + e.getMessage());
        }

        return "admin-dashboard";
    }

    // ==================== CUSTOMER MANAGEMENT ====================
    @GetMapping("/customers")
    public String getAllCustomers(Model model) {
        List<CustomerAccountDTO> customers = adminService.getAllCustomers();
        model.addAttribute("customers", customers);
        return "customerList";
    }

    // ✅ FIXED: Support both GET and POST for activate
    @RequestMapping(value = "/customers/activate/{id}", method = {RequestMethod.GET, RequestMethod.POST})
    public String activateCustomer(@PathVariable Long id) {
        adminService.activateCustomer(id);
        return "redirect:/api/admin/customers";
    }

    // ✅ FIXED: Support both GET and POST for deactivate
    @RequestMapping(value = "/customers/deactivate/{id}", method = {RequestMethod.GET, RequestMethod.POST})
    public String deactivateCustomer(@PathVariable Long id) {
        adminService.deactivateCustomer(id);
        return "redirect:/api/admin/customers";
    }

    @GetMapping("/customers/{id}")
    public String getCustomerById(@PathVariable Long id, Model model) {
        CustomerAccountDTO customer = adminService.getCustomerById(id);
        model.addAttribute("customer", customer);
        return "customerDetails";
    }

    // ==================== ACCOUNT MANAGEMENT ====================
    @GetMapping("/accounts")
    public String getAllAccounts(Model model) {
        List<AccountDTO> accounts = adminService.getAllAccounts();
        model.addAttribute("accounts", accounts);
        return "accountList";
    }

    @GetMapping("/customers/{customerId}/accounts/create")
    public String showCreateAccountPage(@PathVariable Long customerId, Model model) {
        model.addAttribute("customerId", customerId);
        model.addAttribute("accountDTO", new AccountDTO());
        return "createAccount";
    }

    @PostMapping("/customers/{customerId}/accounts")
    public String createAccount(@PathVariable Long customerId, @ModelAttribute AccountDTO accountDTO) {
        adminService.createAccount(customerId, accountDTO);
        return "redirect:/api/admin/accounts";
    }

 // ACCOUNT MANAGEMENT

    @PostMapping("/accounts/update")
    public String updateAccount(@RequestParam Long accountId,
                               @RequestParam Double newBalance,
                               Model model) {
        try {
            AccountDTO accountDTO = new AccountDTO();
            accountDTO.setId(accountId);
            accountDTO.setBalance(newBalance);
            adminService.updateAccount(accountId, accountDTO);
            return "redirect:/api/admin/accounts"; // Redirect back to account list
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/api/admin/accounts";
        }
    }

    @PostMapping("/accounts/delete")
    public String deleteAccount(@RequestParam Long accountId, Model model) {
        try {
            adminService.deleteAccount(accountId);
            return "redirect:/api/admin/accounts";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/api/admin/accounts";
        }
    }



    // ==================== LOAN MANAGEMENT ====================
    @GetMapping("/loans")
    public String getAllLoans(Model model) {
        List<LoanDTO> loans = loanService.getAllLoans();
        model.addAttribute("loans", loans);
        return "loanList";
    }

    @GetMapping("/loans/{id}")
    public String getLoanDetails(@PathVariable Long id, Model model) {
        LoanDTO loan = loanService.getLoanById(id);
        model.addAttribute("loan", loan);
        return "loanDetails";
    }

    @PostMapping("/loans/{id}/approve")
    public String approveLoan(@PathVariable Long id,
                              @RequestParam Double interestRate,
                              @RequestParam(required = false) String remarks) {
        loanService.approveLoan(id, interestRate, remarks);
        return "redirect:/api/admin/loans";
    }

    @PostMapping("/loans/{id}/reject")
    public String rejectLoan(@PathVariable Long id,
                             @RequestParam String remarks) {
        loanService.rejectLoan(id, remarks);
        return "redirect:/api/admin/loans";
    }

    @GetMapping("/support")
    public String showSupport() {
        return "supportList";
    }
}
