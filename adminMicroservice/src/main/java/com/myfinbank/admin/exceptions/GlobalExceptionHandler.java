package com.myfinbank.admin.exceptions;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;

@ControllerAdvice
public class GlobalExceptionHandler {
	
	@ExceptionHandler(AdminAlreadyExistsException.class)
	public ModelAndView handleAdminNotFoundException(HttpServletRequest request, AdminAlreadyExistsException ex){
	
		
		ModelAndView modelAndView = new ModelAndView();
	    modelAndView.addObject("exception", ex.getMessage());
	    modelAndView.addObject("url", request.getRequestURL());
	    
	    modelAndView.setViewName("Error");
	  //  modelAndView.setViewName("redirect:" + ex.getUrl());
	    return modelAndView;
	
	}
}
