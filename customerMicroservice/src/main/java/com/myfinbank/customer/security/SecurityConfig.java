package com.myfinbank.customer.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.myfinbank.customer.security.jwt.JwtAuthenticationFilter;
import com.myfinbank.customer.security.service.CustomerUserDetailsService;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private CustomerUserDetailsService customerUserDetailsService;

    @Autowired
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(customerUserDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder());
        return authProvider;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                // ✅ Allow REST API authentication endpoints (JWT login/register)
                .requestMatchers("/api/customers/auth/**").permitAll()
                
                // ✅ Allow JSP view controller endpoints (Browser - session-based)
                .requestMatchers("/api/customer/**").permitAll()
                
                // ✅ Allow static resources
                .requestMatchers("/css/**", "/js/**", "/images/**", "/static/**").permitAll()
                
                // ✅ Allow ALL /api/customers/** for now (inter-microservice communication)
                // In production, you should add proper service-to-service authentication
                .requestMatchers("/api/customers/**").permitAll()  // ← CHANGED: Allow all customer API calls
                
                // ✅ Allow other API endpoints
                .requestMatchers("/api/accounts/**").permitAll()
                .requestMatchers("/api/transactions/**").permitAll()
                .requestMatchers("/api/loans/**").permitAll()
                .requestMatchers("/api/investments/**").permitAll()
                
                .anyRequest().permitAll()
            )
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authenticationProvider(authenticationProvider())
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
        
        return http.build();
    }
}
