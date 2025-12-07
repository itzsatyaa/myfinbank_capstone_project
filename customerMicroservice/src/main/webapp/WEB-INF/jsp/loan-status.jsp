<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.myfinbank.customer.model.Loan" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Loan Status - MyFinBank</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        
        h2 {
            color: #333;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .search-box {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
        }
        
        .search-box input {
            flex: 1;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 16px;
        }
        
        .search-box button {
            padding: 12px 30px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }
        
        th {
            background: #f8f9fa;
            color: #333;
            font-weight: 600;
        }
        
        tr:hover {
            background: #f8f9fa;
        }
        
        .status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            display: inline-block;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-approved {
            background: #d4edda;
            color: #155724;
        }
        
        .status-rejected {
            background: #f8d7da;
            color: #721c24;
        }
        
        .btn-back {
            margin-top: 20px;
            padding: 12px 30px;
            background: #6c757d;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
        }
        
        .no-loans {
            text-align: center;
            padding: 40px;
            color: #666;
            font-size: 18px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>💼 My Loan Applications</h2>
        
        <div class="search-box">
            <input type="number" id="accountId" placeholder="Enter Account ID" 
                   value="${param.accountId}">
            <button onclick="searchLoans()">Search Loans</button>
        </div>
        
        <% 
            List<Loan> loans = (List<Loan>) request.getAttribute("loans");
            if (loans != null && !loans.isEmpty()) {
        %>
            <table>
                <thead>
                    <tr>
                        <th>Loan ID</th>
                        <th>Loan Type</th>
                        <th>Amount</th>
                        <th>Tenure (Months)</th>
                        <th>Interest Rate</th>
                        <th>Applied Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Loan loan : loans) { %>
                        <tr>
                            <td><%= loan.getId() %></td>
                            <td><%= loan.getLoanType() %></td>
                            <td>₹ <%= String.format("%,.2f", loan.getLoanAmount()) %></td>
                            <td><%= loan.getTenureMonths() %></td>
                            <td><%= loan.getInterestRate() %>%</td>
                            <td><%= loan.getAppliedDate() %></td>
                            <td>
                                <span class="status status-<%= loan.getStatus().toLowerCase() %>">
                                    <%= loan.getStatus() %>
                                </span>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <div class="no-loans">
                <p>No loan applications found. Apply for a loan to get started!</p>
            </div>
        <% } %>
        
        <button class="btn-back" onclick="window.location.href='customer-dashboard.jsp'">
            Back to Dashboard
        </button>
    </div>
    
    <script>
        function searchLoans() {
            const accountId = document.getElementById('accountId').value;
            if (accountId) {
                window.location.href = '${pageContext.request.contextPath}/api/transaction/loanStatus/' + accountId;
            } else {
                alert('Please enter an Account ID');
            }
        }
    </script>
</body>
</html>
