<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Register - MyFinBank</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* General styling */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8fafc; /* Light background */
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
            background-color: #1b5e20; /* Darker green on hover */
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

        /* Input fields */
        input[type="text"], input[type="password"], input[type="email"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            transition: border-color 0.3s;
            box-sizing: border-box;
        }

        /* Input focus styles */
        input[type="text"]:focus, input[type="password"]:focus, input[type="email"]:focus {
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

        /* Error message */
        .error {
            color: red;
            text-align: center;
            margin: 10px 0;
        }

        /* Success message */
        .success {
            color: #2e7d32;
            text-align: center;
            margin: 10px 0;
            font-weight: bold;
        }

        /* Register link */
        .link {
            text-align: center;
            margin-top: 15px;
        }

        .link a {
            color: #388e3c; /* Green link */
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
            margin: 10px auto;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Password strength indicator */
        .password-strength {
            height: 5px;
            border-radius: 3px;
            margin-top: -15px;
            margin-bottom: 15px;
            transition: all 0.3s;
        }

        .strength-weak { background-color: #e74c3c; width: 33%; }
        .strength-medium { background-color: #f39c12; width: 66%; }
        .strength-strong { background-color: #2ecc71; width: 100%; }
    </style>
</head>
<body>
    <nav>
        <ul>
            <li><a href="/api/admin/login"><i class="fas fa-sign-in-alt"></i> Admin Login</a></li>
        </ul>
    </nav>
    <div class="container">
        <h2>Create Admin Account</h2>
        <form id="registerForm" action="/api/admin/register" method="post">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required minlength="3">
            
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>
            
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required minlength="6">
            <div id="passwordStrength" class="password-strength"></div>
            
            <button type="submit" class="btn" id="registerBtn">Register</button>
            <div class="spinner" id="loadingSpinner"></div>
        </form>
        
        <div id="errorMessage" class="error" style="display: none;"></div>
        <div id="successMessage" class="success" style="display: none;"></div>
        
        <p class="link">Already have an account? <a href="/api/admin/login">Login here</a></p>
    </div>

    <script>
        const registerForm = document.getElementById('registerForm');
        const registerBtn = document.getElementById('registerBtn');
        const spinner = document.getElementById('loadingSpinner');
        const errorMessage = document.getElementById('errorMessage');
        const successMessage = document.getElementById('successMessage');
        const passwordInput = document.getElementById('password');
        const passwordStrength = document.getElementById('passwordStrength');

        // Password strength indicator
        passwordInput.addEventListener('input', function() {
            const password = this.value;
            const strength = calculatePasswordStrength(password);
            
            passwordStrength.className = 'password-strength';
            
            if (password.length === 0) {
                passwordStrength.className = 'password-strength';
            } else if (strength < 3) {
                passwordStrength.className = 'password-strength strength-weak';
            } else if (strength < 4) {
                passwordStrength.className = 'password-strength strength-medium';
            } else {
                passwordStrength.className = 'password-strength strength-strong';
            }
        });

        function calculatePasswordStrength(password) {
            let strength = 0;
            if (password.length >= 6) strength++;
            if (password.length >= 10) strength++;
            if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
            if (/\d/.test(password)) strength++;
            if (/[^a-zA-Z0-9]/.test(password)) strength++;
            return strength;
        }

        // Handle registration form submission
        registerForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const username = document.getElementById('username').value.trim();
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value;

            // Validation
            if (username.length < 3) {
                showError('Username must be at least 3 characters long');
                return;
            }

            if (password.length < 6) {
                showError('Password must be at least 6 characters long');
                return;
            }

            // Hide previous messages
            errorMessage.style.display = 'none';
            successMessage.style.display = 'none';

            // Show loading state
            registerBtn.disabled = true;
            registerBtn.textContent = 'Registering...';
            spinner.style.display = 'block';

            try {
                // Try JWT-based registration endpoint first
                const response = await fetch('/api/admin/auth/register', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ 
                        username: username,
                        email: email,
                        password: password 
                    })
                });

                if (response.ok) {
                    const data = await response.json();
                    
                    // Show success message
                    showSuccess('Registration successful! Redirecting to login...');
                    
                    // Clear form
                    registerForm.reset();
                    passwordStrength.className = 'password-strength';
                    
                    // Redirect to login after 2 seconds
                    setTimeout(() => {
                        window.location.href = '/api/admin/login';
                    }, 2000);
                    
                } else if (response.status === 409 || response.status === 400) {
                    // Handle duplicate username or validation errors
                    const errorData = await response.json().catch(() => ({ 
                        message: 'Username already exists or invalid data' 
                    }));
                    showError(errorData.message || 'Registration failed. Username may already exist.');
                    
                } else {
                    // If JWT endpoint doesn't exist, fall back to traditional form submission
                    console.log('JWT registration endpoint not available, using traditional form');
                    registerForm.submit();
                }
                
            } catch (error) {
                console.error('Registration error:', error);
                
                // Fall back to traditional form submission
                showError('Network error. Trying alternative registration method...');
                
                setTimeout(() => {
                    registerForm.submit();
                }, 1500);
                
            } finally {
                // Reset button state
                setTimeout(() => {
                    registerBtn.disabled = false;
                    registerBtn.textContent = 'Register';
                    spinner.style.display = 'none';
                }, 2000);
            }
        });

        function showError(message) {
            errorMessage.textContent = message;
            errorMessage.style.display = 'block';
            successMessage.style.display = 'none';
        }

        function showSuccess(message) {
            successMessage.textContent = message;
            successMessage.style.display = 'block';
            errorMessage.style.display = 'none';
        }

        // Check if already logged in
        window.addEventListener('DOMContentLoaded', function() {
            const token = localStorage.getItem('adminToken');
            if (token) {
                // Verify token and redirect if valid
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
