package com.myfinbank.admin.exceptions;

public class AdminAlreadyExistsException extends Exception{
	String url;
    public AdminAlreadyExistsException(String message,String url){
        super(message);
        this.url=url;
    }
    public String getUrl() {
        return url;
    }
}