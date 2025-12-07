<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.myfinbank.admin.dto.CustomerAccountDTO" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer List - MyFinBank</title>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f5f2;
            color: #2c3e50;
            margin: 0;
            padding: 0;
        }

        nav {
            background-color: #2ecc71;
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
            background-color: #27ae60;
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
            color: #2ecc71;
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
            background-color: #27ae60;
            color: white;
        }

        tr:hover {
            background-color: #eafaf1;
        }

        .action-button {
            background-color: #27ae60;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
            margin: 0 3px;
        }

        .action-button:hover {
            background-color: #229954;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            font-size: 16px;
            color: #2ecc71;
            text-decoration: none;
        }

        .back-link:hover {
            color: #27ae60;
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

    <h1>Customer List</h1>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Email</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<CustomerAccountDTO> customers = (List<CustomerAccountDTO>) request.getAttribute("customers");
                if (customers != null) {
                    for (CustomerAccountDTO customer : customers) {
            %>
            <tr>
                <td><%= customer.getCustomerId() %></td>
                <td><%= customer.getUsername() %></td>
                <td><%= customer.getEmail() %></td>
                <td><%= customer.isActive() ? "Active" : "Inactive" %></td>
                <td>
                    <form action="/api/admin/customers/activate/<%= customer.getCustomerId() %>" method="post"
                          style="display:inline;" onsubmit="return handleFormSubmitWithAuth(event, this);">
                        <input type="submit" value="Activate" class="action-button" />
                    </form>
                    <form action="/api/admin/customers/deactivate/<%= customer.getCustomerId() %>" method="post"
                          style="display:inline;" onsubmit="return handleFormSubmitWithAuth(event, this);">
                        <input type="submit" value="Deactivate" class="action-button" />
                    </form>
                    <a href="/api/admin/customers/<%= customer.getCustomerId() %>" class="action-button"
                       onclick="handleNavigation(event, '/api/admin/customers/<%= customer.getCustomerId() %>')">
                        View Details
                    </a>
                </td>
            </tr>
            <%
                    }
                }
            %>
        </tbody>
    </table>
    <a href="/api/admin/dashboard" class="back-link"
       onclick="handleNavigation(event, '/api/admin/dashboard')">Back to Dashboard</a>

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
                return true; // no JWT: submit normally (session)
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

        // Clear JWT on logout
        document.getElementById('logoutForm').addEventListener('submit', function() {
            localStorage.removeItem('adminToken');
            localStorage.removeItem('adminUsername');
        });

        // Optional auth check
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
