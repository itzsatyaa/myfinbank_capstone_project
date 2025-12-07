<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>  
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Deposit - MyFinBank</title>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #e9f5ec; /* Light green background */
            color: #495057;
            margin: 0;
            padding: 0;
        }

        nav {
            background-color: #2ecc71; /* Green navigation bar */
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
            background-color: #27ae60; /* Darker green on hover */
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
            color: #2ecc71; /* Green heading */
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin: 10px 0 5px;
            font-weight: bold;
        }

        input[type="number"], input[type="text"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            transition: border-color 0.3s;
        }

        input[type="number"]:focus, input[type="text"]:focus {
            border-color: #2ecc71; /* Green focus border */
            outline: none;
        }

        .btn {
            width: 100%;
            padding: 12px;
            background-color: #27ae60; /* Green button */
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
        }

        .btn:hover {
            background-color: #1e8449; /* Darker green on hover */
        }

        .link {
            text-align: center;
            margin-top: 15px;
        }

        .link a {
            color: #27ae60; /* Green link */
        }

        .alert {
            color: red;
            text-align: center;
            margin: 10px 0;
        }
    </style>
</head>
<body>
    <nav>
        <ul>
            <li><a href="/api/customer/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li><a href="/api/customer/account/details"><i class="fas fa-wallet"></i> Account Details</a></li>
        </ul>
    </nav>
    <div class="container">
        <h2>Deposit Funds</h2>
        <form:form modelAttribute="account" action="/api/customer/deposit" method="post">
            <label for="accountId">Account ID:</label>            
            <input type="text" name="accountId" required> <!-- Assuming account object is available -->
            <label for="amount">Amount:</label>
            <input type="number" name="amount" required>
            <button type="submit" class="btn">Deposit</button>
        </form:form>
        <p class="link">Back to <a href="/api/customer/dashboard">Dashboard</a></p>
    </div>
</body>
</html>
