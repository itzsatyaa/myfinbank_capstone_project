package com.myfinbank.customer.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.myfinbank.customer.model.Investment;
import com.myfinbank.customer.service.InvestmentService;

@Controller
@RequestMapping("/api/customer/investments")
public class CustomerInvestmentController {
	
	
	@Autowired
	private InvestmentService investmentService;

	@GetMapping("/invest")
	public String showInvestmentForm() {
	    return "invest"; // Return the JSP view name for the investment form
	}
	 
	@PostMapping("/invest")
	public String invest(@RequestParam Long accountId,
	                     @RequestParam String investmentType,
	                     @RequestParam double amount,
	                     Model model) {
	    try {
	        investmentService.invest(accountId, investmentType, amount);
	        return "redirect:/api/customer/investments/investment?accountId=" + accountId;
	    } catch (RuntimeException ex) {
	        model.addAttribute("errorMessage", ex.getMessage());
	        return "invest";
	    }
	}




	@GetMapping("/investment")
	public String getInvestments(@RequestParam(required = false) Long accountId,
	                             Model model) {
	    if (accountId == null) {
	        model.addAttribute("investments", List.of()); // empty list
	        return "view-investments";
	    }
	    List investments = investmentService.getInvestmentsByAccountId(accountId);
	    model.addAttribute("investments", investments);
	    return "view-investments";
	}



//    @GetMapping
//    public String viewInvestments(Model model, Principal principal) {
//        String username = principal.getName(); // or get customerId via service
//        List<Investment> investments =
//            investmentService.getInvestmentsForCustomer(username); // implement this
//        model.addAttribute("investments", investments);
//        return "view-investments";
//    }


}
