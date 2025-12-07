package com.myfinbank.admin.service;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.myfinbank.admin.model.Admin;
import com.myfinbank.admin.repository.AdminRepository;

@Service
public class AdminService {

	@Autowired
	private AdminRepository adminRepository;
	
	 @Autowired
	    private PasswordEncoder passwordEncoder;

	    


//	@Autowired
//	private RestTemplate restTemplate;
//	
//	// private final RestTemplate restTemplate;
//	private final String CUSTOMER_SERVICE_URL = "http://localhost:9090/api/customers"; // Update with your service URL
//
//	// private final RestTemplate restTemplate;
//	private final String ACCOUNT_SERVICE_URL = "http://localhost:9090/api/accounts"; // Adjust as needed
//
//	// private final RestTemplate restTemplate;
//	private static final String LOAN_SERVICE_URL = "http://localhost:9090/api/loans"; // Adjust the base URL as needed

//
//    public Admin register(Admin admin) {
//        admin.setPassword(passwordEncoder.encode(admin.getPassword()));
//        return adminRepository.save(admin);
//    }
//	public Optional<Admin> login(String username, String password) {
//        return adminRepository.findByUsername(username)
//            .filter(admin -> passwordEncoder.matches(password, admin.getPassword()));
//    }

	 @Transactional
	 public Admin register(Admin admin) {

	     // check duplicate username first
	     if (adminRepository.findByUsername(admin.getUsername()).isPresent()) {
	         throw new RuntimeException("Username already exists");
	     }

	     // encode password before save
	     String encoded = passwordEncoder.encode(admin.getPassword());
	     admin.setPassword(encoded);

	     // save encoded password
	     return adminRepository.save(admin);
	 }


	// Find admin by username
	public Optional<Admin> findByUsername(String username) {
		return adminRepository.findByUsername(username);
	}
}
	
//	public AdminService(RestTemplate restTemplate) {
//		this.restTemplate = restTemplate;
//	}

//	// Retrieve all customers
//	public List<CustomerDTO> getAllCustomers() {
//		// Use getForObject to retrieve a list of customers
//		CustomerDTO[] customers = restTemplate.getForObject(CUSTOMER_SERVICE_URL, CustomerDTO[].class);
//		return List.of(customers); // Convert array to list
//	}
	
//	public List<CustomerDTO> getAllCustomers() {
//	    try {
//	        CustomerDTO[] customers = restTemplate.getForObject(CUSTOMER_SERVICE_URL, CustomerDTO[].class);
//	        return List.of(customers); // Convert array to list
//	    } catch (RestClientException e) {
//	        // Log the exception and handle it accordingly
//	        throw new RuntimeException("Error fetching customers", e);
//	    }
//	}
//
//	// Retrieve a customer by ID
//	public CustomerDTO getCustomerById(Long id) {
//		return restTemplate.getForObject(CUSTOMER_SERVICE_URL + "/" + id, CustomerDTO.class);
//	}
//
//	// Activate a customer
//	public CustomerDTO activateCustomer(Long id) {
//		return restTemplate.postForObject(CUSTOMER_SERVICE_URL + "/" + id + "/activate", null, CustomerDTO.class);
//	}
//
//	// Deactivate a customer
//	public CustomerDTO deactivateCustomer(Long id) {
//		return restTemplate.postForObject(CUSTOMER_SERVICE_URL + "/" + id + "/deactivate", null, CustomerDTO.class);
//	}
//
//	
//	
//	// accounts 
//
//	
//	// Create account
//	public AccountDTO createAccount(AccountDTO accountDTO) {
//		// Validate customer exists
//		CustomerDTO customer = restTemplate.getForObject(CUSTOMER_SERVICE_URL + "/" + accountDTO.getCustomer(),
//				CustomerDTO.class);
//		if (customer == null) {
//			throw new RuntimeException("Customer not found");
//		}
//
//		// Create account
//		return restTemplate.postForObject(ACCOUNT_SERVICE_URL, accountDTO, AccountDTO.class);
//	}
//
//	// Find account by ID
//	public Optional<AccountDTO> findAccountById(Long accountId) {
//		return Optional.ofNullable(restTemplate.getForObject(ACCOUNT_SERVICE_URL + "/" + accountId, AccountDTO.class));
//	}
//
//	// Find all accounts
//	public List<AccountDTO> findAll() {
//		AccountDTO[] accounts = restTemplate.getForObject(ACCOUNT_SERVICE_URL, AccountDTO[].class);
//		return Arrays.asList(accounts);
//	}
//	 // Find all customers
//    public List<CustomerDTO> findAllCustomers() {
//        CustomerDTO[] customers = restTemplate.getForObject(CUSTOMER_SERVICE_URL, CustomerDTO[].class);
//        return Arrays.asList(customers);
//    }
//
//	// Update an account
//	public AccountDTO updateAccount(AccountDTO accountDTO) {
//		// Ensure account exists before updating
//		Optional<AccountDTO> existingAccountOpt = findAccountById(accountDTO.getId());
//		if (existingAccountOpt.isPresent()) {
//			// Validate customer exists
//			CustomerDTO customer = restTemplate.getForObject(CUSTOMER_SERVICE_URL + "/" + accountDTO.getCustomer(),
//					CustomerDTO.class);
//			if (customer == null) {
//				throw new RuntimeException("Customer not found");
//			}
//			restTemplate.put(ACCOUNT_SERVICE_URL + "/" + accountDTO.getId(), accountDTO);
//			return accountDTO; // Return updated account
//		} else {
//			throw new RuntimeException("Account not found");
//		}
//	}
//
//	// Delete an account by ID
//	public void deleteAccount(Long accountId) {
//		restTemplate.delete(ACCOUNT_SERVICE_URL + "/" + accountId);
//	}
//	
//	
//	//LOAN
//	
//	
////    @Autowired
////    public AdminService(RestTemplate restTemplate) {
////        this.restTemplate = restTemplate;
////    }
//
//    public LoanDTO approveLoan(Long loanId) {
//        ResponseEntity<LoanDTO> response = restTemplate.postForEntity(
//                LOAN_SERVICE_URL + "/" + loanId + "/approve", null, LoanDTO.class);
//        return response.getBody();
//    }
//
//    public LoanDTO denyLoan(Long loanId) {
//        ResponseEntity<LoanDTO> response = restTemplate.postForEntity(
//                LOAN_SERVICE_URL + "/" + loanId + "/deny", null, LoanDTO.class);
//        return response.getBody();
//    }
//
//    public List<LoanDTO> findAllLoans() {
//        ResponseEntity<List<LoanDTO>> response = restTemplate.exchange(
//                LOAN_SERVICE_URL, HttpMethod.GET, null, new ParameterizedTypeReference<List<LoanDTO>>() {});
//        return response.getBody();
//    }
//
//    public List<LoanDTO> findLoansByAccountId(Long accountId) {
//        ResponseEntity<List<LoanDTO>> response = restTemplate.exchange(
//                LOAN_SERVICE_URL + "/account/" + accountId, HttpMethod.GET, null, new ParameterizedTypeReference<List<LoanDTO>>() {});
//        return response.getBody();
//    }
//}
