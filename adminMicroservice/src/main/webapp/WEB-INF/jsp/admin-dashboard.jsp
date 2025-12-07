<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.myfinbank.admin.dto.NotificationDTO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - MyFinBank</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* General styling */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8fafc;
            color: #333;
            margin: 0;
            padding: 0;
        }
        
        nav {
            background-color: #2e7d32;
            color: white;
            padding: 20px 30px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        nav h2 { margin: 0; font-size: 24px; font-weight: 600; }
        
        nav ul {
            list-style: none;
            display: flex;
            margin: 0;
            padding: 0;
            align-items: center;
        }
        
        nav ul li { margin-right: 20px; }
        
        nav ul li a {
            color: white;
            text-decoration: none;
            padding: 10px 15px;
            border-radius: 5px;
            font-weight: 500;
            transition: background-color 0.3s ease;
        }
        
        nav ul li a:hover { background-color: #1b5e20; }
        
        .logout-button {
            background: none;
            border: none;
            color: white;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            padding: 10px 15px;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .logout-button:hover {
            background-color: #1b5e20;
        }
        
        .notification-icon-container {
            position: relative;
            display: inline-block;
            cursor: pointer;
        }
        
        .notification-icon { font-size: 24px; color: white; }
        
        .notification-badge {
            position: absolute;
            top: -8px;
            right: -8px;
            background-color: #e74c3c;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: bold;
        }
        
        .notification-box {
            display: none;
            position: fixed;
            top: 70px;
            right: 20px;
            width: 400px;
            max-height: 500px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
            z-index: 1000;
            overflow: hidden;
        }
        
        .notification-box.active {
            display: block;
            animation: slideIn 0.3s ease-out;
        }
        
        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .notification-header {
            background-color: #2e7d32;
            color: white;
            padding: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .notification-header h3 { margin: 0; font-size: 18px; }
        
        .close-notifications {
            background: none;
            border: none;
            color: white;
            font-size: 20px;
            cursor: pointer;
        }
        
        .notification-content {
            max-height: 400px;
            overflow-y: auto;
            padding: 10px;
        }
        
        .notification-item {
            padding: 15px;
            border-bottom: 1px solid #e0e0e0;
            transition: background-color 0.2s;
        }
        
        .notification-item:hover { background-color: #f5f5f5; }
        .notification-item:last-child { border-bottom: none; }
        
        .notification-message {
            color: #333;
            font-size: 14px;
            margin-bottom: 5px;
            line-height: 1.5;
        }
        
        .notification-time { color: #999; font-size: 12px; }
        
        .notification-status {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: bold;
            margin-left: 10px;
        }
        
        .status-sent {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status-failed {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        .no-notifications {
            text-align: center;
            padding: 40px;
            color: #999;
        }
        
        .no-notifications i {
            font-size: 48px;
            margin-bottom: 10px;
            display: block;
        }
        
        h1 {
            text-align: center;
            margin-top: 40px;
            color: #2e7d32;
            font-size: 28px;
            font-weight: 600;
        }
        
        .action-list {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 25px;
            padding: 40px 20px;
            max-width: 1100px;
            margin: auto;
        }
        
        .action-list a {
            background-color: #66bb6a;
            color: white;
            padding: 30px 20px;
            border-radius: 12px;
            text-decoration: none;
            text-align: center;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            font-size: 18px;
            font-weight: 500;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        
        .action-list a i { font-size: 28px; margin-bottom: 10px; }
        
        .action-list a:hover {
            transform: scale(1.03);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
        }

        .admin-info {
            display: flex;
            align-items: center;
            color: white;
            margin-right: 20px;
        }

        .admin-info i {
            margin-right: 8px;
        }
        
        @media (max-width: 992px) {
            .action-list { grid-template-columns: repeat(2, 1fr); }
        }
        
        @media (max-width: 600px) {
            .action-list { grid-template-columns: 1fr; }
            nav ul { flex-wrap: wrap; }
            .notification-box { width: 90%; right: 5%; }
        }
    </style>
</head>
<body>
<%
    List<NotificationDTO> notifications = (List<NotificationDTO>) request.getAttribute("notifications");
    int notifCount = (notifications != null) ? notifications.size() : 0;
%>

    <nav>
        <h2>MyFinBank</h2>
        <ul>
            <li class="admin-info">
                <i class="fas fa-user-shield"></i>
                <span id="adminUsername">Admin</span>
            </li>
            <li><a href="/api/admin/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li><a href="/api/admin/customers"><i class="fas fa-users"></i> Manage Customers</a></li>
            <li><a href="/api/admin/loans"><i class="fas fa-money-bill"></i> Manage Loans</a></li>
            <li>
                <div class="notification-icon-container" onclick="toggleNotifications()">
                    <i class="fas fa-bell notification-icon"></i>
                    <% if (notifCount > 0) { %>
                        <span class="notification-badge"><%= notifCount %></span>
                    <% } %>
                </div>
            </li>
            <li>
                <button type="button" class="logout-button" onclick="handleLogout()">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </button>
            </li>
        </ul>
    </nav>

    <div id="notificationBox" class="notification-box">
        <div class="notification-header">
            <h3>🔔 Notifications</h3>
            <button class="close-notifications" onclick="toggleNotifications()">×</button>
        </div>
        <div class="notification-content">
            <% if (notifications != null && !notifications.isEmpty()) { %>
                <% for (NotificationDTO notification : notifications) { %>
                    <div class="notification-item">
                        <div class="notification-message">
                            <%= notification.getMessage() %>
                            <span class="notification-status <%= "SENT".equals(notification.getStatus()) ? "status-sent" : "status-failed" %>">
                                <%= notification.getStatus() %>
                            </span>
                        </div>
                        <div class="notification-time">
                            <i class="far fa-clock"></i>
                            <%= (notification.getSentAt() != null) ? notification.getSentAt().toString() : "Recently" %>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <div class="no-notifications">
                    <i class="far fa-bell-slash"></i>
                    <p>No notifications yet</p>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Hidden form for traditional logout -->
    <form id="logoutForm" action="/api/admin/logout" method="POST" style="display: none;">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
    </form>

    <h1>Welcome to the Admin Dashboard</h1>
    <div class="action-list">
        <a href="/api/admin/customers"><i class="fas fa-users"></i> View Customers</a>
        <a href="/api/admin/accounts"><i class="fas fa-list"></i> View Accounts</a>
        <a href="/api/admin/loans"><i class="fas fa-money-bill"></i> View Loans</a>
        <a href="/api/admin/support"><i class="fas fa-headset"></i> Customer Support</a>
    </div>

    <script>
        // Get JWT token from localStorage
        const token = localStorage.getItem('adminToken');
        const username = localStorage.getItem('adminUsername');

        // Display username if available
        if (username) {
            document.getElementById('adminUsername').textContent = username;
        }

        // Function to add JWT token to all API requests
        function addAuthorizationHeader(url, options = {}) {
            const token = localStorage.getItem('adminToken');
            if (token) {
                options.headers = options.headers || {};
                options.headers['Authorization'] = 'Bearer ' + token;
            }
            return fetch(url, options);
        }

        // Check authentication on page load
        window.addEventListener('DOMContentLoaded', function() {
            const token = localStorage.getItem('adminToken');
            
            if (!token) {
                // No token found, might be session-based login
                console.log('No JWT token found, using session authentication');
                return;
            }

            // Verify token is valid by making a request
            addAuthorizationHeader('/api/admin/dashboard')
                .then(response => {
                    if (!response.ok && response.status === 401) {
                        // Token expired or invalid
                        console.log('Token invalid, redirecting to login');
                        localStorage.removeItem('adminToken');
                        localStorage.removeItem('adminUsername');
                        window.location.href = '/api/admin/login';
                    }
                })
                .catch(error => {
                    console.error('Authentication check failed:', error);
                });
        });

        // Handle logout
        function handleLogout() {
            const token = localStorage.getItem('adminToken');
            
            if (token) {
                // JWT-based logout
                localStorage.removeItem('adminToken');
                localStorage.removeItem('adminUsername');
                
                // Optional: Call backend logout endpoint
                addAuthorizationHeader('/api/admin/logout', {
                    method: 'POST'
                }).finally(() => {
                    window.location.href = '/api/admin/login';
                });
            } else {
                // Traditional form-based logout
                document.getElementById('logoutForm').submit();
            }
        }

        // Notification toggle function
        function toggleNotifications() {
            const box = document.getElementById('notificationBox');
            box.classList.toggle('active');
        }

        // Close notifications when clicking outside
        document.addEventListener('click', function(event) {
            const box = document.getElementById('notificationBox');
            const icon = document.querySelector('.notification-icon-container');
            
            if (!box.contains(event.target) && !icon.contains(event.target)) {
                box.classList.remove('active');
            }
        });

        // Override all anchor tag clicks to add JWT token for navigation
        document.addEventListener('DOMContentLoaded', function() {
            const links = document.querySelectorAll('a[href^="/api/admin/"]');
            
            links.forEach(link => {
                link.addEventListener('click', function(e) {
                    const token = localStorage.getItem('adminToken');
                    if (token) {
                        // Store token for next page
                        sessionStorage.setItem('pendingAuth', 'true');
                    }
                });
            });
        });
    </script>
</body>
</html>
