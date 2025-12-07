<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.myfinbank.customer.dto.AccountDTO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Dashboard - MyFinBank</title>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #e9f5ec; /* Light green background */
            color: #495057;
            margin: 0;
            padding: 0;
        }

        nav {
            background-color: #2ecc71; /* Green navigation bar */
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
            background-color: #27ae60; /* Darker green on hover */
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
            color: #2ecc71; /* Green heading */
        }

        .action-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 20px;
            padding: 20px;
            max-width: 800px;
            margin: auto;
        }

        .action-list a {
            background-color: #27ae60; /* Green background for action items */
            color: white;
            padding: 20px;
            border-radius: 8px;
            text-decoration: none;
            text-align: center;
            transition: background-color 0.3s, transform 0.3s;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            font-size: 16px;
        }

        .action-list a:hover {
            background-color: #1e8449; /* Darker green on hover */
            transform: translateY(-3px);
        }

        .action-list i {
            display: block;
            font-size: 24px;
            margin-bottom: 10px;
        }

        /* Notification Icon Styles */
        .notification-icon-container {
            position: relative;
            display: inline-block;
            cursor: pointer;
        }

        .notification-icon {
            font-size: 24px;
            color: white;
            position: relative;
        }

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

        /* Notification Box Styles */
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
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .notification-header {
            background-color: #2ecc71;
            color: white;
            padding: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .notification-header h3 {
            margin: 0;
            font-size: 18px;
        }

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

        .notification-item:hover {
            background-color: #f5f5f5;
        }

        .notification-item:last-child {
            border-bottom: none;
        }

        .notification-message {
            color: #333;
            font-size: 14px;
            margin-bottom: 5px;
            line-height: 1.5;
        }

        .notification-time {
            color: #999;
            font-size: 12px;
        }

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

        /* Scrollbar Styles */
        .notification-content::-webkit-scrollbar {
            width: 6px;
        }

        .notification-content::-webkit-scrollbar-track {
            background: #f1f1f1;
        }

        .notification-content::-webkit-scrollbar-thumb {
            background: #2ecc71;
            border-radius: 10px;
        }

        .notification-content::-webkit-scrollbar-thumb:hover {
            background: #27ae60;
        }

        @media (max-width: 600px) {
            nav ul {
                flex-direction: column;
                align-items: center;
            }
            nav ul li {
                margin-bottom: 10px;
            }
            .notification-box {
                width: 90%;
                right: 5%;
            }
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
                <!-- Notification Icon -->
                <div class="notification-icon-container" onclick="toggleNotifications()">
                    <i class="fas fa-bell notification-icon"></i>
                    <c:if test="${not empty notifications}">
                        <c:set var="notifCount" value="${notifications.size()}" />
                        <c:if test="${notifCount > 0}">
                            <span class="notification-badge">${notifCount}</span>
                        </c:if>
                    </c:if>
                </div>
            </li>
            <li>
                <form action="/api/customer/logout" method="POST" style="display: inline;">
                    <button type="submit" class="logout-button">Logout</button>
                </form>
            </li>
        </ul>
    </nav>
    

    <!-- Notification Box -->
    <div id="notificationBox" class="notification-box">
        <div class="notification-header">
            <h3>🔔 Notifications</h3>
            <button class="close-notifications" onclick="toggleNotifications()">×</button>
        </div>
        <div class="notification-content">
            <c:choose>
                <c:when test="${not empty notifications}">
                    <c:forEach items="${notifications}" var="notification">
                        <div class="notification-item">
                            <div class="notification-message">
                                ${notification.message}
                                <span class="notification-status status-${notification.status == 'SENT' ? 'sent' : 'failed'}">
                                    ${notification.status}
                                </span>
                            </div>
                            <div class="notification-time">
                                <i class="far fa-clock"></i>
                                <%
                                    // Format date in Java instead of JSTL
                                    Object sentAtObj = pageContext.getAttribute("notification");
                                    if (sentAtObj != null) {
                                        try {
                                            com.myfinbank.customer.dto.NotificationDTO notif = 
                                                (com.myfinbank.customer.dto.NotificationDTO) sentAtObj;
                                            if (notif.getSentAt() != null) {
                                                SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy hh:mm a");
                                                out.print(sdf.format(notif.getSentAt()));
                                            } else {
                                                out.print("Just now");
                                            }
                                        } catch (Exception e) {
                                            out.print("Recently");
                                        }
                                    }
                                %>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-notifications">
                        <i class="far fa-bell-slash"></i>
                        <p>No notifications yet</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <h1>Welcome to Your Dashboard</h1>
    <div class="action-list">
    <a href="/api/customer/accounts"><i class="fas fa-eye"></i> View Account Details</a>
    <a href="/api/customer/deposit"><i class="fas fa-plus"></i> Deposit Funds</a>
    <a href="/api/customer/withdraw"><i class="fas fa-minus"></i> Withdraw Funds</a>
    <a href="/api/customer/transfer"><i class="fas fa-exchange-alt"></i> Transfer Funds</a>
    <a href="/api/customer/transactions"><i class="fas fa-history"></i> View Transactions</a>
    <a href="/api/customer/calculate-emi"><i class="fas fa-calculator"></i> Calculate Loan EMI</a>
    <a href="/api/customer/apply-loan"><i class="fas fa-paper-plane"></i> Apply for Loan</a>

    <!-- New Loan Status button -->
    <a href="/api/customer/loan-status"><i class="fas fa-clipboard-list"></i> View Loan Status</a>

    <a href="/api/customer/investments/invest"><i class="fas fa-dollar-sign"></i> Invest</a>
    <a href="/api/customer/investments/investment?accountId=${account.id}">
    <i class="fas fa-list"></i> View Investments
</a>


   
<a href="/api/customer/support" class="btn">
    <i class="fas fa-headset"></i> Customer Support
</a>

</div>
    

    <script>
        // Toggle notification box
        function toggleNotifications() {
            const box = document.getElementById('notificationBox');
            box.classList.toggle('active');
        }

        // Close notification box when clicking outside
        document.addEventListener('click', function(event) {
            const box = document.getElementById('notificationBox');
            const icon = document.querySelector('.notification-icon-container');

            if (!box.contains(event.target) && !icon.contains(event.target)) {
                box.classList.remove('active');
            }
        });
    </script>
</body>
</html>
