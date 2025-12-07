<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>  
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Withdraw - MyFinBank</title>
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

        input[type="text"], input[type="number"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            transition: border-color 0.3s;
        }

        input[type="text"]:focus, input[type="number"]:focus {
            border-color: #2ecc71; /* Green border on focus */
            outline: none;
        }

        .btn {
            width: 100%;
            padding: 12px;
            background-color: #28a745; /* Green button */
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
        }

        .btn:hover {
            background-color: #218838; /* Darker green on hover */
        }

        .link {
            text-align: center;
            margin-top: 15px;
        }

        .link a {
            color: #28a745; /* Green link */
            text-decoration: none;
        }

        .link a:hover {
            text-decoration: underline; /* Underline on hover */
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
        <h2>Withdraw Funds</h2>
        <form action="/api/customer/withdraw" method="post">
            <label for="accountId">Account ID:</label>
            <input type="text" name="accountId" required>
            <label for="amount">Amount:</label>
            <input type="number" name="amount" required>
            <button type="submit" class="btn">Withdraw</button>
        </form>
        <p class="link">Back to <a href="/api/customer/dashboard">Dashboard</a></p>
    </div>
</body>
</html>
