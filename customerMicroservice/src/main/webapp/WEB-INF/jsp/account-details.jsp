<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>  
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Account Details - MyFinBank</title>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f5f2;
            color: #495057;
            margin: 0;
            padding: 0;
        }

        nav {
            background-color: #2ecc71;
            color: white;
            padding: 15px 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        nav ul {
            list-style: none;
            padding: 0;
            display: flex;
            justify-content: space-between;
        }

        nav ul li a {
            color: white;
            text-decoration: none;
            padding: 10px 15px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        nav ul li a:hover {
            background-color: #27ae60;
        }

        .container {
            width: 400px;
            margin: auto;
            padding: 30px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            margin-top: 50px;
        }

        h2 {
            text-align: center;
            color: #2ecc71;
            margin-bottom: 20px;
        }

        p {
            font-size: 18px;
            margin: 10px 0;
        }

        .btn {
            display: block;
            width: 100%;
            padding: 12px;
            background-color: #27ae60;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
            text-align: center;
        }

        .btn:hover {
            background-color: #229954;
        }
    </style>
</head>
<body>	
	<form:form id="custAcctForm" modelAttribute="account">  
	
    <nav>
        <ul>
            <li><a href="/api/customer/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li><a href="/api/customer/deposit"><i class="fas fa-plus"></i> Deposit</a></li>
            <li><a href="/api/customer/withdraw"><i class="fas fa-minus"></i> Withdraw</a></li>
        </ul>
    </nav>
    
    <div class="container">
        <h2>Your Account Details</h2>
        <p>Account Number: ${account.accountNumber}</p>
        <p>Balance: ${account.balance}</p>
        <button class="btn" onclick="window.location.href='/api/customer/dashboard'">Back to Dashboard</button>
    </div>
    </form:form>
</body>
</html>
