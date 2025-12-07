<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>  
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register - MyFinBank</title>
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
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        nav ul {
            list-style: none;
            padding: 0;
            display: flex;
            justify-content: flex-end;
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

        .container {
            width: 400px;
            margin: auto;
            padding: 30px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            margin-top: 50px;
        }

        h2 {
            text-align: center;
            color: #2ecc71; /* Green heading */
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin: 10px 0 5px;
            font-weight: bold;
        }

        input[type="text"], input[type="password"], input[type="email"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            transition: border-color 0.3s;
        }

        input[type="text"]:focus, input[type="password"]:focus, input[type="email"]:focus {
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

        .error {
            color: red;
            text-align: center;
            margin: 10px 0;
        }

        .link {
            text-align: center;
            margin-top: 15px;
        }

        .link a {
            color: #27ae60; /* Green link */
        }
    </style>
</head>
<body>
    <nav>
        <ul>
            <li><a href="/api/customer/login"><i class="fas fa-user-plus"></i> Login</a></li>
        </ul>
    </nav>
    <div class="container">
        <h2>Create Your Account</h2>
        <form action="/api/customer/register" method="post">
            <label for="username">Username:</label>
            <input type="text" name="username" required>
            <label for="email">Email:</label>
            <input type="email" name="email" required>
            <label for="password">Password:</label>
            <input type="password" name="password" required>
            <button type="submit" class="btn">Register</button>
        </form>
        <p class="link">Already have an account? <a href="/api/customer/login">Login here</a></p>
    </div>
</body>
</html>
