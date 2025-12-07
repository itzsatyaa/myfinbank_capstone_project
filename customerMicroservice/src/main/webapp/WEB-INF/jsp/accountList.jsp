<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.myfinbank.customer.model.Account" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Account List - MyFinBank</title>
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
            background-color: #27ae60;
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
            background-color: #229954;
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
            color: #27ae60;
        }

        table {
            width: 80%;
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
            background-color: #2ecc71;
            color: white;
        }

        tr:hover {
            background-color: #e8f5e9;
        }

        .action-button {
            background-color: #27ae60;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .action-button:hover {
            background-color: #229954;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            font-size: 16px;
            color: #27ae60;
            text-decoration: none;
        }

        .back-link:hover {
            color: #229954;
        }
    </style>
</head>
<body>
    <nav>
        <div>
            <h2 style="margin: 0;">MyFinBank</h2>
        </div>
        <ul>
            <li><a href="/api/customer/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li><a href="/api/customer/applyloan"><i class="fas fa-paper-plane"></i> Apply For Loans</a></li>
            <li>
                <form action="/api/customer/logout" method="POST" style="display: inline;">
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
            </tr>
        </thead>
        <tbody>
            <%
                List<Account> accounts = (List<Account>) request.getAttribute("accounts");
                if (accounts != null) {
                    for (Account account : accounts) {
            %>
            <tr>
                <td><%= account.getId() %> </td>
                <td><%= account.getAccountNumber() %></td>
                <td><%= account.getBalance() %></td>
            </tr>
            <%
                    }
                }
            %>
        </tbody>
    </table>
    <a href="/api/customer/dashboard" class="back-link">Back to Dashboard</a>
</body>
</html>
