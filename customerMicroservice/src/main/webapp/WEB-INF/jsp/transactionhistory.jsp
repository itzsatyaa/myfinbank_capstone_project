<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Transaction History - MyFinBank</title>
<link rel="stylesheet" href="/css/styles.css">
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #eafaf1;
        color: #2f4f4f;
        margin: 0;
        padding: 0;
    }
    nav {
        background-color: #4caf50;
        padding: 15px;
    }
    nav ul {
        list-style-type: none;
        padding: 0;
        margin: 0;
        display: flex;
    }
    nav li {
        margin-right: 20px;
    }
    nav a {
        color: white;
        text-decoration: none;
        font-weight: bold;
    }
    nav a:hover {
        text-decoration: underline;
    }
    .container {
        margin: 20px auto;
        max-width: 1200px;
        padding: 20px;
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    h2 {
        color: #4caf50;
        text-align: center;
    }
    .view-form {
        text-align: center;
        margin: 30px 0;
        padding: 30px;
        background-color: #f8f9fa;
        border-radius: 8px;
    }
    .view-form h2 {
        color: #4caf50;
        margin-bottom: 10px;
    }
    .view-form p {
        color: #666;
        margin-bottom: 20px;
    }
    .btn-view {
        background-color: #4caf50;
        color: white;
        padding: 12px 30px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
        font-weight: bold;
        text-decoration: none;
        display: inline-block;
        transition: background-color 0.3s;
    }
    .btn-view:hover {
        background-color: #45a049;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }
    th, td {
        padding: 12px;
        text-align: left;
        border: 1px solid #4caf50;
    }
    th {
        background-color: #d9f2e6;
        color: #4caf50;
        font-weight: bold;
    }
    tr:nth-child(even) {
        background-color: #f2f2f2;
    }
    tr:hover {
        background-color: #c8e6c9;
    }
    .badge-DEPOSIT {
        background-color: #28a745;
        color: white;
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 12px;
    }
    .badge-WITHDRAW {
        background-color: #dc3545;
        color: white;
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 12px;
    }
    .badge-TRANSFER {
        background-color: #007bff;
        color: white;
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 12px;
    }
    .badge-INVESTMENT {
        background-color: #ffc107;
        color: #000;
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 12px;
    }
    .link {
        margin-top: 20px;
        text-align: center;
    }
    .link a {
        color: #4caf50;
        text-decoration: none;
        font-weight: bold;
    }
    .link a:hover {
        text-decoration: underline;
    }
    .alert {
        padding: 15px;
        margin-bottom: 20px;
        border-radius: 5px;
    }
    .alert-info {
        background-color: #d1ecf1;
        border: 1px solid #bee5eb;
        color: #0c5460;
    }
    .alert-danger {
        background-color: #f8d7da;
        border: 1px solid #f5c6cb;
        color: #721c24;
    }
    .no-transactions {
        text-align: center;
        padding: 40px;
        color: #666;
        font-style: italic;
    }
</style>
</head>
<body>
<nav>
<ul>
<li><a href="/api/customer/dashboard" aria-label="Dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
<li><a href="/api/customer/account/details" aria-label="Account Details"><i class="fas fa-wallet"></i> Account Details</a></li>
</ul>
</nav>
<div class="container">
    <h2>View Transactions Form</h2>
    
    <!-- Display Messages -->
    <c:if test="${not empty message}">
        <div class="alert alert-info">${message}</div>
    </c:if>
    
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <!-- View Transactions Form -->
    <div class="view-form">
        <h2>View Transactions Form</h2>
        <p>Click the button to view all your transactions.</p>
        <a href="/api/customer/transactions" class="btn-view">
            <i class="fas fa-list"></i> View All Transactions
        </a>
    </div>

    <!-- Transaction Table -->
    <c:if test="${not empty transactions}">
        <h3 style="text-align: center; color: #4caf50; margin-top: 30px;">Transaction History</h3>
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
                <c:forEach items="${transactions}" var="transaction">
                <tr>
                    <td>
                        <fmt:formatDate value="${transaction.date}" pattern="yyyy-MM-dd HH:mm:ss" />
                    </td>
                    <td>
                        <span class="badge-${transaction.type}">${transaction.type}</span>
                    </td>
                    <td>₹ <fmt:formatNumber value="${transaction.amount}" pattern="#,##0.00" /></td>
                    <td>₹ <fmt:formatNumber value="${transaction.balanceAfter}" pattern="#,##0.00" /></td>
                </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
    
    <c:if test="${empty transactions and empty message and empty error}">
        <div class="no-transactions">
            <i class="fas fa-info-circle" style="font-size: 48px; color: #ccc;"></i>
            <p>Click "View All Transactions" to see your transaction history.</p>
        </div>
    </c:if>

    <p class="link">Back to <a href="/api/customer/dashboard"><i class="fas fa-home"></i> Dashboard</a></p>
</div>

</body>
</html>
