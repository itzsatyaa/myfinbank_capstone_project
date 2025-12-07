<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Support - MyFinBank</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8fafc;
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
        
        nav h2 { margin: 0; font-size: 24px; }
        
        nav a {
            color: white;
            text-decoration: none;
            padding: 10px 15px;
            border-radius: 5px;
            font-weight: 500;
            transition: background-color 0.3s;
        }

        nav a:hover {
            background-color: #1b5e20;
        }
        
        .container {
            max-width: 800px;
            margin: 60px auto;
            padding: 40px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .container i {
            font-size: 80px;
            color: #2e7d32;
            margin-bottom: 20px;
        }
        
        .container h1 {
            color: #2e7d32;
            margin-bottom: 20px;
        }
        
        .container p {
            color: #666;
            font-size: 18px;
            margin-bottom: 30px;
        }
        
        .btn {
            background-color: #2e7d32;
            color: white;
            padding: 12px 24px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: background-color 0.3s;
        }

        .btn:hover {
            background-color: #1b5e20;
        }
    </style>
</head>
<body>
    <nav>
        <h2>MyFinBank Admin - Customer Support</h2>
        <a href="/api/admin/dashboard" onclick="handleNavigation(event, '/api/admin/dashboard')">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </nav>
    
    <div class="container">
        <i class="fas fa-headset"></i>
        <h1>Customer Support</h1>
        <p>Customer support feature coming soon!</p>
        <p>For now, you can contact customers directly via email or phone.</p>
        <a href="/api/admin/customers" class="btn"
           onclick="handleNavigation(event, '/api/admin/customers')">
            <i class="fas fa-users"></i> View All Customers
        </a>
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
            if (!token) {
                return; // session-based
            }
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
    </script>
</body>
</html>
