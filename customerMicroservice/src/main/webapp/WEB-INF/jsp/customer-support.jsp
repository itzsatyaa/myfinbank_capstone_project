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
            background-color: #1976d2;
            color: white;
            padding: 20px 30px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        nav h2 { 
            margin: 0; 
            font-size: 24px; 
        }
        
        nav a {
            color: white;
            text-decoration: none;
            padding: 10px 15px;
            border-radius: 5px;
            font-weight: 500;
            transition: background-color 0.3s;
        }

        nav a:hover {
            background-color: #1565c0;
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
            color: #1976d2;
            margin-bottom: 20px;
        }
        
        .container h1 {
            color: #1976d2;
            margin-bottom: 20px;
        }
        
        .container p {
            color: #666;
            font-size: 18px;
            margin-bottom: 30px;
        }
        
        .support-info {
            background: #e3f2fd;
            padding: 20px;
            border-radius: 8px;
            margin: 30px 0;
            text-align: left;
        }
        
        .support-info h3 {
            color: #1976d2;
            margin-bottom: 15px;
        }
        
        .support-info p {
            margin: 10px 0;
            font-size: 16px;
        }
        
        .support-info i {
            font-size: 16px;
            margin-right: 8px;
            color: #1976d2;
        }
        
        .btn {
            background-color: #1976d2;
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
            background-color: #1565c0;
        }
    </style>
</head>
<body>
    <nav>
        <h2>MyFinBank - Customer Support</h2>
        <a href="/api/customer/dashboard">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </nav>
    
    <div class="container">
        <i class="fas fa-headset"></i>
        <h1>Customer Support</h1>
        <p>We're here to help! Reach out to us through any of the following channels:</p>
        
        <div class="support-info">
            <h3><i class="fas fa-info-circle"></i> Contact Information</h3>
            <p><i class="fas fa-phone"></i> <strong>Phone:</strong> 1800-123-4567 (Toll Free)</p>
            <p><i class="fas fa-envelope"></i> <strong>Email:</strong> support@myfinbank.com</p>
            <p><i class="fas fa-clock"></i> <strong>Working Hours:</strong> Mon-Fri: 9:00 AM - 6:00 PM IST</p>
            <p><i class="fas fa-map-marker-alt"></i> <strong>Address:</strong> MyFinBank Head Office, Mumbai, India</p>
        </div>
        
        <p style="margin-top: 30px;">For immediate assistance with your account, visit your dashboard.</p>
        
        <a href="/api/customer/dashboard" class="btn">
            <i class="fas fa-tachometer-alt"></i> Go to Dashboard
        </a>
    </div>
</body>
</html>
