<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.myfinbank.admin.dto.CustomerAccountDTO" %>
<%@ page import="com.myfinbank.admin.dto.AccountDTO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Detail - MyFinBank</title>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f2f5; /* Light background */
            color: #495057; /* Darker text for readability */
            margin: 0;
            padding: 0;
        }

        nav {
            background-color: #2e7d32; /* Dark green header */
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
            background-color: #1b5e20; /* Darker green on hover */
        }

        .logout-button {
            background: none;
            border: none;
            color: white;
            cursor: pointer;
            font-size: 16px;
        }

        h1, h2 {
            text-align: center;
            color: #2e7d32; /* Green for headings */
            margin: 20px 0;
        }

        .customer-info {
            margin: 20px auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            max-width: 600px;
        }

        .customer-info p {
            margin: 10px 0;
        }

        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 12px;
            text-align: center;
            border: 1px solid #ddd;
        }

        th {
            background-color: #4caf50; /* Header green */
            color: white;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        .action-button {
            background-color: #4caf50; /* Primary green button */
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

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            font-size: 16px;
            color: #2e7d32;
            text-decoration: none;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        .center-button {
            display: flex;
            justify-content: center;
            margin: 20px 0;
        }
        
        .btn-update {
    background-color: #4caf50;
    color: white;
    padding: 8px 15px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    margin-right: 5px;
}

.btn-update:hover {
    background-color: #45a049;
}

.btn-delete {
    background-color: #f44336;
    color: white;
    padding: 8px 15px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

.btn-delete:hover {
    background-color: #da190b;
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
                <form id="logoutForm" action="/api/admin/logout" method="POST" style="display: inline;">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    <button type="submit" class="logout-button">Logout</button>
                </form>
            </li>
        </ul>
    </nav>

    <h1>Customer Detail</h1>
    <%
        CustomerAccountDTO customer = (CustomerAccountDTO) request.getAttribute("customer");
        if (customer != null) {
    %>
    <div class="customer-info">
        <p><strong>ID:</strong> <%= customer.getCustomerId() %></p>
        <p><strong>Username:</strong> <%= customer.getUsername() %></p>
        <p><strong>Email:</strong> <%= customer.getEmail() %></p>
        <p><strong>Status:</strong> <%= customer.isActive() ? "Active" : "Inactive" %></p>
    </div>

  <h2>Accounts</h2>
<table>
    <thead>
        <tr>
            <th>Account Number</th>
            <th>Balance</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach items="${customer.accounts}" var="account">
        <tr>
            <td>${account.accountNumber}</td>
            <td>₹${account.balance}</td>
            <td>
                <!-- Update Button -->
                <form action="${pageContext.request.contextPath}/api/admin/accounts/update" 
                      method="POST" 
                      style="display:inline;">
                    <input type="hidden" name="accountId" value="${account.id}"/>
                    <input type="hidden" name="customerId" value="${customer.customerId}"/>
                    <input type="number" name="newBalance" placeholder="New Balance" 
                           step="0.01" required style="width: 120px;"/>
                    <button type="submit" class="btn-update">
                        <i class="fas fa-edit"></i> Update
                    </button>
                </form>
                
                <!-- Delete Button -->
                <form action="${pageContext.request.contextPath}/api/admin/accounts/delete" 
                      method="POST" 
                      style="display:inline;" 
                      onsubmit="return confirm('Are you sure you want to delete account ${account.accountNumber}?');">
                    <input type="hidden" name="accountId" value="${account.id}"/>
                    <input type="hidden" name="customerId" value="${customer.customerId}"/>
                    <button type="submit" class="btn-delete">
                        <i class="fas fa-trash"></i> Delete
                    </button>
                </form>
            </td>
        </tr>
        </c:forEach>
    </tbody>
</table>


    <div class="center-button">
        <a href="/api/admin/customers/<%= customer.getCustomerId() %>/accounts/create" class="action-button"
           onclick="handleNavigation(event, '/api/admin/customers/<%= customer.getCustomerId() %>/accounts/create')">
            Create New Account
        </a>
    </div>

    <a href="/api/admin/customers" class="back-link"
       onclick="handleNavigation(event, '/api/admin/customers')">Back to Customer List</a>
    <%
        }
    %>

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

        function handleFormSubmitWithAuth(event, form) {
            const token = getToken();
            if (!token) {
                return true; // allow normal submit
            }

            event.preventDefault();
            const url = form.action;
            const formData = new FormData(form);
            const body = new URLSearchParams();
            formData.forEach((value, key) => body.append(key, value));

            fetchWithAuth(url, {
                method: form.method || 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: body.toString()
            }).then(response => {
                if (response.ok) {
                    window.location.reload();
                } else if (response.status === 401 || response.status === 403) {
                    alert('Session expired. Please login again.');
                    localStorage.removeItem('adminToken');
                    localStorage.removeItem('adminUsername');
                    window.location.href = '/api/admin/login';
                } else {
                    alert('Action failed. Please try again.');
                }
            }).catch(() => alert('Action failed. Please try again.'));
            return false;
        }

        // Logout handler (uses session + optional JWT clear)
        document.getElementById('logoutForm').addEventListener('submit', function() {
            localStorage.removeItem('adminToken');
            localStorage.removeItem('adminUsername');
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
