<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Account Detail - MyFinBank</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* General styling */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #e0f7e9; /* Light green background */
            color: #2e7d32; /* Dark green text color */
            margin: 0;
            padding: 20px;
        }

        /* Navigation bar */
        nav {
            background-color: #2e7d32;
            color: white;
            padding: 15px 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            margin: -20px -20px 30px -20px;
        }

        nav ul {
            list-style: none;
            padding: 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 0;
        }

        nav ul li a {
            color: white;
            text-decoration: none;
            padding: 10px 15px;
            border-radius: 5px;
            transition: background-color 0.3s;
            display: flex;
            align-items: center;
        }

        nav ul li a i {
            margin-right: 8px;
        }

        nav ul li a:hover {
            background-color: #1b5e20;
        }

        nav h2 {
            margin: 0;
            font-size: 20px;
        }

        /* Header styling */
        h1 {
            color: #1b5e20; /* Darker green for the header */
            border-bottom: 2px solid #2e7d32;
            padding-bottom: 10px;
            text-align: center;
            margin-top: 20px;
        }

        /* Paragraph styling */
        p {
            font-size: 1.1em;
            color: #388e3c; /* Medium green color */
        }

        /* Link styling */
        a {
            color: #2e7d32; /* Dark green */
            text-decoration: none;
            font-weight: bold;
        }

        a:hover {
            color: #1b5e20; /* Darker green on hover */
        }

        /* Container for account details */
        .account-details {
            background-color: #ffffff; /* White card background */
            border: 2px solid #66bb6a;
            padding: 25px;
            border-radius: 12px;
            max-width: 500px;
            margin: 20px auto;
            text-align: left;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .account-details p {
            margin: 15px 0;
            padding: 10px;
            background-color: #f1f8f4;
            border-radius: 5px;
        }

        .account-details strong {
            color: #1b5e20;
            display: inline-block;
            min-width: 150px;
        }

        /* Back link container */
        .back-link {
            text-align: center;
            margin-top: 30px;
        }

        .back-link a {
            background-color: #4caf50;
            color: white;
            padding: 12px 30px;
            border-radius: 5px;
            display: inline-flex;
            align-items: center;
            transition: background-color 0.3s;
        }

        .back-link a i {
            margin-right: 8px;
        }

        .back-link a:hover {
            background-color: #388e3c;
        }

        /* Loading state */
        .loading {
            text-align: center;
            padding: 40px;
            color: #666;
        }

        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #2e7d32;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 20px auto;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Error message */
        .error-message {
            background-color: #ffebee;
            color: #c62828;
            padding: 15px;
            border-radius: 5px;
            margin: 20px auto;
            max-width: 500px;
            text-align: center;
            border: 1px solid #ef5350;
        }
    </style>
</head>
<body>
    <nav>
        <ul>
            <li><h2><i class="fas fa-university"></i> MyFinBank</h2></li>
            <li><a href="/api/admin/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
        </ul>
    </nav>

    <h1><i class="fas fa-file-invoice-dollar"></i> Account Details</h1>

    <div class="account-details" id="accountDetails">
        <p><strong><i class="fas fa-hashtag"></i> Account ID:</strong> ${account.id}</p>
        <p><strong><i class="fas fa-credit-card"></i> Account Number:</strong> ${account.accountNumber}</p>
        <p><strong><i class="fas fa-wallet"></i> Balance:</strong> ₹${account.balance}</p>
        <p><strong><i class="fas fa-user"></i> Customer ID:</strong> ${account.customerId}</p>
    </div>

    <div class="back-link">
        <a href="/api/admin/accounts" onclick="handleNavigation(event, '/api/admin/accounts')">
            <i class="fas fa-arrow-left"></i> Back to Account List
        </a>
    </div>

    <script>
        // Function to get JWT token
        function getToken() {
            return localStorage.getItem('adminToken');
        }

        // Function to add Authorization header to fetch requests
        function fetchWithAuth(url, options = {}) {
            const token = getToken();
            if (token) {
                options.headers = options.headers || {};
                options.headers['Authorization'] = 'Bearer ' + token;
            }
            return fetch(url, options);
        }

        // Handle navigation with JWT token
        function handleNavigation(event, url) {
            const token = getToken();
            if (token) {
                event.preventDefault();
                
                // Verify token before navigation
                fetchWithAuth(url)
                    .then(response => {
                        if (response.ok) {
                            window.location.href = url;
                        } else if (response.status === 401 || response.status === 403) {
                            // Token expired or invalid
                            alert('Session expired. Please login again.');
                            localStorage.removeItem('adminToken');
                            localStorage.removeItem('adminUsername');
                            window.location.href = '/api/admin/login';
                        } else {
                            window.location.href = url;
                        }
                    })
                    .catch(error => {
                        console.error('Navigation error:', error);
                        window.location.href = url;
                    });
            }
            // If no token, allow normal navigation (session-based)
        }

        // Check authentication on page load
        window.addEventListener('DOMContentLoaded', function() {
            const token = getToken();
            
            if (token) {
                // Verify token is still valid
                fetchWithAuth('/api/admin/accounts')
                    .then(response => {
                        if (!response.ok && response.status === 401) {
                            // Token expired
                            console.log('Token expired, redirecting to login');
                            localStorage.removeItem('adminToken');
                            localStorage.removeItem('adminUsername');
                            window.location.href = '/api/admin/login';
                        }
                    })
                    .catch(error => {
                        console.error('Authentication check failed:', error);
                    });
            }
        });

        // Optional: Load account details via API if needed
        function loadAccountDetailsViaAPI(accountId) {
            const loading = document.createElement('div');
            loading.className = 'loading';
            loading.innerHTML = '<div class="spinner"></div><p>Loading account details...</p>';
            
            const accountDetails = document.getElementById('accountDetails');
            const originalContent = accountDetails.innerHTML;
            accountDetails.innerHTML = '';
            accountDetails.appendChild(loading);

            fetchWithAuth('/api/admin/accounts/' + accountId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Failed to load account details');
                    }
                    return response.json();
                })
                .then(data => {
                    accountDetails.innerHTML = `
                        <p><strong><i class="fas fa-hashtag"></i> Account ID:</strong> ${data.id}</p>
                        <p><strong><i class="fas fa-credit-card"></i> Account Number:</strong> ${data.accountNumber}</p>
                        <p><strong><i class="fas fa-wallet"></i> Balance:</strong> ₹${data.balance}</p>
                        <p><strong><i class="fas fa-user"></i> Customer ID:</strong> ${data.customerId}</p>
                    `;
                })
                .catch(error => {
                    console.error('Error loading account details:', error);
                    accountDetails.innerHTML = originalContent; // Restore original content from JSP
                });
        }
    </script>
</body> 
</html>
