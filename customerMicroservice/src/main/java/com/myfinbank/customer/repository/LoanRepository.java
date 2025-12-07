package com.myfinbank.customer.repository;

import com.myfinbank.customer.model.Loan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface LoanRepository extends JpaRepository<Loan, Long> {
    List<Loan> findByCustomerId(Long customerId);
    List<Loan> findByCustomerEmail(String email);
    List<Loan> findByStatus(String status);

    

}
