<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Loan Denial Result</title>
</head>
<body>
    <h1>Loan Denied</h1>
    <p>Loan ID: ${loan.id}</p>
    <p>Amount: ${loan.amount}</p>
    <p>Status: ${loan.status}</p>
    <a href="/admin/loans">Back to Loan List</a>
</body>
</html>