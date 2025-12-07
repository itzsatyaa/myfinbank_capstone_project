<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>  
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Apply for Loan - MyFinBank</title>
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

        .container {
            width: 450px;
            margin: 50px auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
            color: #333;
        }

        input[type="number"], select {
            width: 100%;
            padding: 12px;
            margin-top: 8px;
            border-radius: 5px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

        input[type="submit"] {
            width: 100%;
            padding: 12px;
            margin-top: 20px;
            background-color: #27ae60;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        input[type="submit"]:hover {
            background-color: #229954;
        }

        .message {
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 15px;
            text-align: center;
        }

        .success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .back-btn {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: #27ae60;
            text-decoration: none;
            font-weight: bold;
        }

        .back-btn:hover {
            text-decoration: underline;
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
            <li><a href="/api/customer/accounts"><i class="fas fa-wallet"></i> Account Details</a></li>
            <li>
                <form action="/api/customer/logout" method="POST" style="display: inline;">
                    <button type="submit" class="logout-button">Logout</button>
                </form>
            </li>
        </ul>
    </nav>

    <div class="container">
        <h1>💰 Apply for a Loan</h1>

        <!-- Success Message -->
        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="message success">
                <%= request.getAttribute("successMessage") %>
            </div>
        <% } %>

        <!-- Error Message -->
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="message error">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <form action="/api/customer/apply-loan" method="POST">
            
            <!-- Loan Type Dropdown -->
            <label for="loanType">Loan Type: *</label>
            <select id="loanType" name="loanType" required>
                <option value="">-- Select Loan Type --</option>
                <option value="PERSONAL">Personal Loan</option>
                <option value="HOME_LOAN">Home Loan</option>
                <option value="CAR_LOAN">Car Loan</option>
                <option value="EDUCATION_LOAN">Education Loan</option>
                <option value="BUSINESS_LOAN">Business Loan</option>
            </select>

            <!-- Loan Amount -->
            <label for="loanAmount">Loan Amount (₹): *</label>
            <input type="number" id="loanAmount" name="loanAmount" 
                   min="10000" max="10000000" step="1000" required 
                   placeholder="Enter amount (e.g., 50000)">

            <!-- Tenure in Months -->
            <label for="tenureMonths">Loan Tenure (Months): *</label>
            <input type="number" id="tenureMonths" name="tenureMonths" 
                   min="6" max="360" step="6" required 
                   placeholder="Enter tenure (e.g., 24)">

            <input type="submit" value="Submit Loan Application">
        </form>

        <a href="/api/customer/dashboard" class="back-btn">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>
</body>
</html>
