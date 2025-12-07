<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.myfinbank.admin.dto.CustomerAccountDTO" %>
<%@ page import="com.myfinbank.admin.dto.AccountDTO" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create Account - MyFinBank</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f2f5; /* Light background */
            color: #495057;
            margin: 0;
            padding: 0;
        }

        nav {
            background-color: #2e7d32; /* Green header */
            color: white;
            padding: 15px 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        nav h2 {
            margin: 0;
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
            background-color: #1b5e20; /* Darker green on hover */
        }

        h1 {
            text-align: center;
            margin-top: 30px;
            color: #2e7d32; /* Green for headings */
        }

        .form-container {
            width: 80%;
            margin: 20px auto;
            padding: 20px;
            background-color: white;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }

        label {
            display: block;
            margin: 10px 0 5px;
        }

        input[type="text"],
        input[type="number"],
        select {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            transition: border-color 0.3s;
            box-sizing: border-box;
        }

        input[type="text"]:focus,
        input[type="number"]:focus {
            border-color: #2e7d32; /* Green border on focus */
            outline: none;
        }

        input[type="submit"] {
            background-color: #4caf50; /* Primary green button */
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        input[type="submit"]:hover {
            background-color: #388e3c; /* Darker green on hover */
        }

        a {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #2e7d32; /* Green link color */
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline; /* Underline effect on hover */
        }

        .error-message {
            color: red;
            text-align: center;
            margin-bottom: 10px;
        }

        .success-message {
            color: #2e7d32;
            text-align: center;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <nav>
        <h2>MyFinBank Admin</h2>
        <ul>
            <li><a href="/api/admin/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li><a href="/api/admin/customers"><i class="fas fa-users"></i> Manage Customers</a></li>
            <li><a href="/api/admin/accounts"><i class="fas fa-money-bill-wave"></i> Manage Accounts</a></li>
        </ul>
    </nav>

    <div class="form-container">
        <h1>Create Account for Customer ID: <%= request.getAttribute("customerId") %></h1>

        <div id="messageContainer"></div>

        <form id="createAccountForm" action="/api/admin/customers/<%= request.getAttribute("customerId") %>/accounts" method="post">
            <label for="accountNumber">Account Number:</label>
            <input type="text" id="accountNumber" name="accountNumber" required>

            <label for="balance">Initial Balance:</label>
            <input type="number" id="balance" name="balance" step="0.01" required>

            <input type="submit" value="Create Account">
        </form>
        
        <a href="/api/admin/customers" onclick="handleNavigation(event, '/api/admin/customers')">Back to Customer List</a>
    </div>

    <script>
        function getToken() {
            return localStorage.getItem('adminToken');
        }

        function fetchWithAuth(url, options = {}) {
            const token = getToken();
            if (token) {
                options.headers = options.headers || {};
                options.headers['Authorization'] = 'Bearer ' + token;
            }
            return fetch(url, options);
        }

        function handleNavigation(event, url) {
            const token = getToken();
            if (token) {
                event.preventDefault();
                fetchWithAuth(url)
                    .then(response => {
                        if (response.ok) {
                            window.location.href = url;
                        } else if (response.status === 401 || response.status === 403) {
                            alert('Session expired. Please login again.');
                            localStorage.removeItem('adminToken');
                            localStorage.removeItem('adminUsername');
                            window.location.href = '/api/admin/login';
                        } else {
                            window.location.href = url;
                        }
                    })
                    .catch(() => window.location.href = url);
            }
        }

        // Optional: intercept form submit to use JWT (while still allowing normal POST)
        document.getElementById('createAccountForm').addEventListener('submit', function(e) {
            const token = getToken();
            if (!token) {
                // No token: let normal form submit happen (session-based)
                return;
            }

            e.preventDefault();
            const form = this;
            const url = form.action;
            const formData = new FormData(form);
            const body = new URLSearchParams();

            formData.forEach((value, key) => body.append(key, value));

            fetchWithAuth(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: body.toString()
            })
            .then(response => {
                if (response.ok) {
                    document.getElementById('messageContainer').innerHTML =
                        '<p class="success-message">Account created successfully.</p>';
                    setTimeout(() => {
                        window.location.href = '/api/admin/accounts';
                    }, 1000);
                } else if (response.status === 401 || response.status === 403) {
                    alert('Session expired. Please login again.');
                    localStorage.removeItem('adminToken');
                    localStorage.removeItem('adminUsername');
                    window.location.href = '/api/admin/login';
                } else {
                    document.getElementById('messageContainer').innerHTML =
                        '<p class="error-message">Failed to create account. Please try again.</p>';
                }
            })
            .catch(() => {
                document.getElementById('messageContainer').innerHTML =
                    '<p class="error-message">Error occurred while creating account.</p>';
            });
        });

        // Auth check on load (optional)
        window.addEventListener('DOMContentLoaded', function() {
            const token = getToken();
            if (token) {
                fetchWithAuth('/api/admin/dashboard')
                    .then(response => {
                        if (!response.ok && response.status === 401) {
                            localStorage.removeItem('adminToken');
                            localStorage.removeItem('adminUsername');
                            window.location.href = '/api/admin/login';
                        }
                    });
            }
        });
    </script>
</body>
</html>
