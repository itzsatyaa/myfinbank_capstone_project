<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Transactions - MyFinBank</title>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #eafaf1; /* Light green background */
            color: #495057; /* Darker text for contrast */
            margin: 0;
            padding: 0;
        }

        nav {
            background-color: #4caf50; /* Green navbar */
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
            background-color: #388e3c; /* Darker green on hover */
        }

        .container {
            width: 600px;
            margin: auto;
            padding: 30px;
            background: white; /* White background for container */
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            margin-top: 50px;
        }

        h2 {
            text-align: center;
            color: #4caf50; /* Green heading */
            margin-bottom: 20px;
        }

        label {
            color: #4caf50; /* Green label color */
        }

        input[type="number"] {
            border: 1px solid #4caf50; /* Green border for input */
            padding: 10px;
            border-radius: 5px;
            margin-top: 10px;
            margin-bottom: 20px;
            width: calc(100% - 22px); /* Full width minus padding */
        }

        button {
            background-color: #4caf50; /* Green button */
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #388e3c; /* Darker green on button hover */
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #d9f2e6; /* Light green for header */
            color: #4caf50; /* Dark green text */
        }

        .link {
            text-align: center;
        }

        .link a {
            color: #4caf50; /* Green link color */
            text-decoration: underline;
        }

        .link a:hover {
            color: #388e3c; /* Darker green on link hover */
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
    <h2>View Transactions Form</h2>
    <form action="/api/customer/transactions" method="get">
    <p style="color:#4caf50;">Click the button to view all your transactions.</p>
    <button type="submit">View All Transactions</button>
</form>
    

    <%
    if (request.getAttribute("message") != null) {
    %>
    <div style="color: green;">
        <%= request.getAttribute("message") %>
    </div>
    <%
    }
    %>
    <%
    if (request.getAttribute("error") != null) {
    %>
    <div style="color: red;">
        <%= request.getAttribute("error") %>
    </div>
    <%
    }
    %>
    <table>
        <thead>
            <tr>
                <th>Date</th>
                <th>Type</th>
                <th>Amount</th>
                <th>Balance After</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="transaction" items="${transactions}">
                <tr>
                    <td>${transaction.date}</td>
                    <td>${transaction.type}</td>
                    <td>${transaction.amount}</td>
                    <td>${transaction.balanceAfter}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <p class="link">
        Back to <a href="/api/customer/dashboard">Dashboard</a>
    </p>
</div>
</body>
</html>
