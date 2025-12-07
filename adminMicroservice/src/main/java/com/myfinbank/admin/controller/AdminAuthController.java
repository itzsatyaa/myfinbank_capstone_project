package com.myfinbank.admin.controller;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.ResponseBody;

import com.myfinbank.admin.security.jwt.JwtUtil;
import com.myfinbank.admin.security.model.AuthRequest;
import com.myfinbank.admin.security.model.AuthResponse;
import com.myfinbank.admin.security.service.AdminUserDetailsService;


import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.myfinbank.admin.model.Admin;
import com.myfinbank.admin.repository.AdminRepository;
import com.myfinbank.admin.service.AdminService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/api/admin")
@CrossOrigin(origins = "http://localhost:58837")
public class AdminAuthController {
 
	@Autowired
	private AdminService adminService;
	
	@Autowired
	private AdminRepository adminRepository;
	
	@Autowired
	private AuthenticationManager authenticationManager;

	@Autowired
	private JwtUtil jwtUtil;

	@Autowired
	private AdminUserDetailsService adminUserDetailsService;


	@GetMapping("/register")
	public String showRegistrationForm(Model model) {
		model.addAttribute("admin", new Admin());
		return "admin-register"; // JSP view for admin registration
	} 

	@PostMapping("/register")
	public String registerAdmin(@ModelAttribute Admin admin, Model model) {
		// Register admin and get the saved Admin object
		adminService.register(admin);

		// Optional: Add a success message if needed
		model.addAttribute("successMessage", "Admin registered successfully!");

		return "redirect:/api/admin/login"; // Redirect to login page after registration
	}

	// Admin Login
	@GetMapping("/login")
	public String login() {
		return "admin-login"; // JSP view for admin login
	}

	@PostMapping("/login")
	public String login(@ModelAttribute Admin admin, Model model) {
	    // Fetch the admin from the database
	    Optional<Admin> optionalAdmin = adminRepository.findByUsername(admin.getUsername());

	    // Check if the admin exists and the password matches
	    if (optionalAdmin.isPresent() && admin.getPassword().equals(optionalAdmin.get().getPassword())) {
	        // Optionally, set the admin in the session or perform additional actions
	        return "redirect:/api/admin/dashboard"; // Redirect to dashboard on success
	    } else {
	        model.addAttribute("error", "Invalid username or password.");
	        return "admin-login"; // Return to login page on failure
	    }
	}
	
	// JWT login (REST) - returns token
	@PostMapping("/auth/login")
	@ResponseBody
	public AuthResponse authenticateAdmin(@RequestBody AuthRequest authRequest) {
	    try {
	        Authentication authentication = authenticationManager.authenticate(
	                new UsernamePasswordAuthenticationToken(
	                        authRequest.getUsername(),
	                        authRequest.getPassword()
	                )
	        );

	        UserDetails userDetails =
	                adminUserDetailsService.loadUserByUsername(authRequest.getUsername());

	        String token = jwtUtil.generateToken(userDetails);

	        return new AuthResponse(token);

	    } catch (BadCredentialsException ex) {
	        // In a real API, you'd return 401 with an error body; for simplicity just rethrow
	        throw new RuntimeException("Invalid username or password");
	    }
	}

	
//	@GetMapping("/dashboard")
//	public String showDashboard(Model model, HttpSession session) {
//	    // Retrieve admin ID from session
//	    Long adminId = (Long) session.getAttribute("adminId");
//	    
//	    if (adminId != null) {
//	        Admin admin = adminService.findByAdminId(adminId)
//	                .orElseThrow(() -> new RuntimeException("Admin not found"));
//	       model.addAttribute("admin", admin);
//	    }
//	    
//	    return "admin-dashboard"; // Return admin-dashboard view
//	}

	
	@PostMapping("/logout")
	public String logoutAdmin(HttpSession session) {
		session.invalidate(); // Invalidate the session
		return "redirect:/api/admin/login?logout=true"; // Redirect to login page with a logout parameter
	}

//	@PostMapping("/admin/login")
//	public String login(@ModelAttribute Admin admin, Model model) {
//		try {
//			Authentication authentication = authenticationManager
//					.authenticate(new UsernamePasswordAuthenticationToken(admin.getUsername(), admin.getPassword()));
//			return "redirect:/admin/dashboard"; // Redirect to dashboard or other page on success
//		} catch (AuthenticationException e) {
//			model.addAttribute("error", "Invalid username or password.");
//			return "admin-login"; // Return to login page on failure
//		}
//	}

	//accounts
	
//	// Show create account form
//    @GetMapping("/account/create")
//    public String showCreateAccountForm(Model model) {
//        model.addAttribute("accountDTO", new AccountDTO());
//        return "createAccount";
//    }
//
//    // Create a new account
//    @PostMapping("/accounts")
//    public String createAccount(@ModelAttribute AccountDTO accountDTO) {
//        adminService.createAccount(accountDTO);
//        return "redirect:/admin/accounts"; // Redirect to accounts list
//    }
//
//    // Get all accounts
//    @GetMapping("/accounts")
//    public String getAllAccounts(Model model) {
//        List<AccountDTO> accounts = adminService.findAll();
//        model.addAttribute("accounts", accounts);
//        return "accountList"; // JSP page to list accounts
//    }
//
//    // Get account by ID
//    @GetMapping("/{id}")
//    public String getAccountById(@PathVariable Long id, Model model) {
//        AccountDTO account = adminService.findAccountById(id).orElse(null);
//        model.addAttribute("account", account);
//        return "accountDetails"; // JSP page to show account details
//    }
//
//    // Show update account form
//    @GetMapping("/update/{id}")
//    public String showUpdateAccountForm(@PathVariable Long id, Model model) {
//        AccountDTO account = adminService.findAccountById(id).orElse(null);
//        model.addAttribute("accountDTO", account);
//        return "updateAccount"; // JSP page to update account
//    }
//
//    // Update an existing account
//    @PostMapping("/update/{id}")
//    public String updateAccount(@PathVariable Long id, @ModelAttribute AccountDTO accountDTO) {
//        accountDTO.setId(id);
//        adminService.updateAccount(accountDTO);
//        return "redirect:/admin/accounts"; // Redirect to accounts list
//    }
//
//    // Delete an account by ID
//    @GetMapping("/delete/{id}")
//    public String deleteAccount(@PathVariable Long id) {
//        adminService.deleteAccount(id);
//        return "redirect:/admin/accounts"; // Redirect to accounts list
//    }

	
	
//	@GetMapping("/loans")
//	public List<Loan> getAllLoans() {
//		return loanService.findAllLoans(); // Fetch all loans
//	}

//	@PostMapping("/approveLoan/{loanId}")
//	public Loan approveLoan(@PathVariable Long loanId) {
//		return loanService.approveLoan(loanId); // Approve the loan based on balance/	}

//	@PostMapping("/denyLoan/{loanId}")
//	public Loan denyLoan(@PathVariable Long loanId) {
//		return loanService.denyLoan(loanId); // Deny the loan
//	}

}
