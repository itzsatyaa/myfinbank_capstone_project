<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>  
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Invest - MyFinBank</title>
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

        .container {
            width: 400px;
            margin: auto;
            padding: 30px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            margin-top: 50px;
        }

        label {
            display: block;
            margin: 10px 0 5px;
            font-weight: bold;
        }

        input[type="text"], input[type="number"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            transition: border-color 0.3s;
        }

        input[type="text"]:focus, input[type="number"]:focus {
            border-color: #2ecc71; /* Green focus border */
            outline: none;
        }

        .btn {
            width: 100%;
            padding: 12px;
            background-color: #27ae60; /* Green button */
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
        }

        .btn:hover {
            background-color: #1e8449; /* Darker green on hover */
        }

        @media (max-width: 600px) {
            nav ul {
                flex-direction: column;
                align-items: center;
            }
            nav ul li {
                margin-bottom: 10px;
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
            <li><a href="/api/customer/account/details"><i class="fas fa-wallet"></i> Account Details</a></li>
            <li>
                <form action="/api/customer/logout" method="POST" style="display: inline;">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    <button type="submit" class="logout-button">Logout</button>
                </form>
            </li>
        </ul>
    </nav>

    <h1>Invest in Your Future</h1>
    <div class="container">
        <form action="/api/customer/investments/invest" method="post">
            <label for="accountId">Account ID:</label>
            <input type="text" name="accountId" required>
            <label for="investmentType">Investment Type:</label>
            <input type="text" name="investmentType" required>
            <label for="amount">Amount:</label>
            <input type="number" name="amount" required>
            <button type="submit" class="btn">Invest</button>
        </form>
    </div>
</body>
</html>
