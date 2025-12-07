<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Login - MyFinBank</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* General styling */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8fafc;
            color: #495057;
            margin: 0;
            padding: 0;
        }

        /* Navigation bar */
        nav {
            background-color: #2e7d32; /* Green header */
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
            background-color: #1b5e20;
        }

        /* Form container */
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
            color: #2e7d32; /* Green theme for header text */
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin: 10px 0 5px;
            font-weight: bold;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            transition: border-color 0.3s;
            box-sizing: border-box;
        }

        input[type="text"]:focus, input[type="password"]:focus {
            border-color: #2e7d32; /* Green border on focus */
            outline: none;
        }

        /* Button styling */
        .btn {
            width: 100%;
            padding: 12px;
            background-color: #4caf50; /* Primary green button */
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
        }

        .btn:hover {
            background-color: #388e3c; /* Darker green on hover */
        }

        .btn:disabled {
            background-color: #a5d6a7;
            cursor: not-allowed;
        }

        .error {
            color: red;
            text-align: center;
            margin: 10px 0;
        }

        .success {
            color: green;
            text-align: center;
            margin: 10px 0;
        }

        /* Register link */
        .link {
            text-align: center;
            margin-top: 15px;
        }

        .link a {
            color: #388e3c;
            text-decoration: none;
        }

        .link a:hover {
            text-decoration: underline;
        }

        /* Loading spinner */
        .spinner {
            display: none;
            width: 20px;
            height: 20px;
            border: 3px solid #f3f3f3;
            border-top: 3px solid #2e7d32;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <nav>
        <ul>
            <li><a href="/api/admin/register"><i class="fas fa-user-plus"></i> Register</a></li>
        </ul>
    </nav>
    <div class="container">
        <h2>Welcome Back, Admin</h2>
        <form id="loginForm" action="/api/admin/login" method="post">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
            <button type="submit" class="btn" id="loginBtn">Login</button>
            <div class="spinner" id="loadingSpinner"></div>
        </form>
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>
        <div id="errorMessage" class="error" style="display: none;"></div>
        <div id="successMessage" class="success" style="display: none;"></div>
        <p class="link">Don't have an account? <a href="/api/admin/register">Register here</a></p>
    </div>

    <script>
        document.getElementById('loginForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            const loginBtn = document.getElementById('loginBtn');
            const spinner = document.getElementById('loadingSpinner');
            const errorMessage = document.getElementById('errorMessage');
            const successMessage = document.getElementById('successMessage');

            // Hide previous messages
            errorMessage.style.display = 'none';
            successMessage.style.display = 'none';

            // Show loading state
            loginBtn.disabled = true;
            loginBtn.textContent = 'Logging in...';
            spinner.style.display = 'block';

            try {
                // First, try JWT-based login
                const response = await fetch('/api/admin/auth/login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ username, password })
                });

                if (response.ok) {
                    const data = await response.json();
                    
                    // Store JWT token in localStorage
                    localStorage.setItem('adminToken', data.token);
                    localStorage.setItem('adminUsername', username);
                    
                    // Show success message
                    successMessage.textContent = 'Login successful! Redirecting...';
                    successMessage.style.display = 'block';
                    
                    // Redirect to dashboard after short delay
                    setTimeout(() => {
                        window.location.href = '/api/admin/dashboard';
                    }, 1000);
                } else {
                    // If JWT login fails, fall back to form-based login
                    const errorData = await response.json().catch(() => ({ message: 'Invalid username or password' }));
                    
                    // Try traditional form submission
                    this.submit();
                }
            } catch (error) {
                console.error('Login error:', error);
                
                // Fall back to traditional form submission
                errorMessage.textContent = 'Network error. Trying alternative login method...';
                errorMessage.style.display = 'block';
                
                setTimeout(() => {
                    this.submit();
                }, 1500);
            } finally {
                // Reset button state after a delay
                setTimeout(() => {
                    loginBtn.disabled = false;
                    loginBtn.textContent = 'Login';
                    spinner.style.display = 'none';
                }, 2000);
            }
        });

        // Check if already logged in
        window.addEventListener('DOMContentLoaded', function() {
            const token = localStorage.getItem('adminToken');
            if (token) {
                // Verify token is still valid
                fetch('/api/admin/dashboard', {
                    headers: {
                        'Authorization': 'Bearer ' + token
                    }
                }).then(response => {
                    if (response.ok) {
                        window.location.href = '/api/admin/dashboard';
                    } else {
                        // Token invalid, clear it
                        localStorage.removeItem('adminToken');
                        localStorage.removeItem('adminUsername');
                    }
                });
            }
        });
    </script>
</body>
</html>
