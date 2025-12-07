package com.myfinbank.customer.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.myfinbank.customer.exceptions.CustomerAlreadyExistsException;
import com.myfinbank.customer.model.Customer;
import com.myfinbank.customer.security.jwt.JwtUtil;
import com.myfinbank.customer.security.model.AuthRequest;
import com.myfinbank.customer.security.model.AuthResponse;
import com.myfinbank.customer.security.service.CustomerUserDetailsService;
import com.myfinbank.customer.service.CustomerService;

@RestController
@RequestMapping("/api/customers/auth")
@CrossOrigin(origins = "http://localhost:5157")
public class CustomerAuthController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private CustomerUserDetailsService customerUserDetailsService;
    
    @Autowired
    private CustomerService customerService;
    
    @PostMapping("/register")
    public ResponseEntity<?> registerCustomer(@RequestBody Customer customer) {
        try {
            
            Customer registeredCustomer = customerService.register(customer);
            return ResponseEntity.ok("Customer registered successfully with ID: " + registeredCustomer.getId());
        } catch (CustomerAlreadyExistsException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Registration failed: " + e.getMessage());
        }
    }


    @PostMapping("/login")
    public ResponseEntity<?> authenticateCustomer(@RequestBody AuthRequest authRequest) {
        try {
            authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(authRequest.getUsername(), authRequest.getPassword())
            );

            UserDetails userDetails = customerUserDetailsService.loadUserByUsername(authRequest.getUsername());
            String token = jwtUtil.generateToken(userDetails);

            return ResponseEntity.ok(new AuthResponse(token));
        } catch (BadCredentialsException ex) {
            return ResponseEntity.status(401).body("Invalid username or password");
        }
    }
}
