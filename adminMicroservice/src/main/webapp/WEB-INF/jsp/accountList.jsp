<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.myfinbank.admin.dto.AccountDTO" %>
<%@ page import="com.myfinbank.admin.dto.CustomerAccountDTO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Account List - MyFinBank</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #e8f5e9;
            color: #2e7d32;
            margin: 0;
            padding: 0;
        }

        nav {
            background-color: #388e3c;
            color: white;
            padding: 15px 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        nav ul {
            list-style: none;
            padding: 0;
            display: flex;
        }

        nav ul li {
            margin-right: 20px;
        }

        nav ul li a {
            color: white;
            text-decoration: none;
            padding: 10px 15px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        nav ul li a:hover {
            background-color: #2e7d32;
        }

        .logout-button {
            background: none;
            border: none;
            color: white;
            cursor: pointer;
            font-size: 16px;
        }

        h1 {
            text-align: center;
            margin-top: 30px;
            color: #388e3c;
        }

        table {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 12px;
            text-align: center;
            border: 1px solid #ddd;
        }

        th {
            background-color: #66bb6a;
            color: white;
        }

        tr:hover {
            background-color: #c8e6c9;
        }

        .action-button {
            background-color: #4caf50;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
            margin: 0 5px;
        }

        .action-button:hover {
            background-color: #388e3c;
        }

        .action-button.delete {
            background-color: #f44336;
        }

        .action-button.delete:hover {
            background-color: #d32f2f;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            font-size: 16px;
            color: #2e7d32;
            text-decoration: none;
        }

        .back-link:hover {
            color: #1b5e20;
            text-decoration: underline;
        }

        input[type="number"] {
            width: 100px;
            padding: 6px;
            border: 1px solid #4caf50;
            border-radius: 4px;
        }

        td form {
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
    </style>
</head>
<body>
    <nav>
        <div>
            <h2 style="margin: 0;">MyFinBank</h2>
        </div>
        <ul>
            <li><a href="/api/admin/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li><a href="/api/admin/customers"><i class="fas fa-users"></i> Manage Customers</a></li>
            <li><a href="/api/admin/loans"><i class="fas fa-money-bill"></i> Manage Loans</a></li>
            <li>
                <form action="/api/admin/logout" method="POST" style="display: inline;">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    <button type="submit" class="logout-button">Logout</button>
                </form>
            </li>
        </ul>
    </nav>

    <h1>Accounts for Customers:</h1>
    <table>
        <thead>
            <tr>
                <th>Account ID</th>
                <th>Account Number</th>
                <th>Balance</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${accounts}" var="account">
            <tr>
                <td>${account.id}</td>
                <td>${account.accountNumber}</td>
                <td>₹${account.balance}</td>
                <td>
                    <!-- Update Form -->
                    <form action="/api/admin/accounts/update" method="POST" style="display:inline;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                        <input type="hidden" name="accountId" value="${account.id}">
                        <input type="hidden" name="customerId" value="0"> <!-- You may need to pass actual customer ID -->
                        <input type="number" name="newBalance" step="0.01" placeholder="New Balance" required>
                        <button type="submit" class="action-button">
                            <i class="fas fa-edit"></i> Update
                        </button>
                    </form>
                    
                    <!-- Delete Form -->
                    <form action="/api/admin/accounts/delete" method="POST" style="display:inline;" 
                          onsubmit="return confirm('Are you sure you want to delete account ${account.accountNumber}?');">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                        <input type="hidden" name="accountId" value="${account.id}">
                        <input type="hidden" name="customerId" value="0"> <!-- You may need to pass actual customer ID -->
                        <button type="submit" class="action-button delete">
                            <i class="fas fa-trash"></i> Delete
                        </button>
                    </form>
                </td>
            </tr>
            </c:forEach>
        </tbody>
    </table>
    <a href="/api/admin/customers" class="back-link">
        <i class="fas fa-arrow-left"></i> Back to Customer List
    </a>
</body>
</html>
