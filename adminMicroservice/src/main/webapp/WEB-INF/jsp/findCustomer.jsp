<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Find Customer</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f5f2;
            color: #2c3e50;
            margin: 0;
            padding: 20px;
            text-align: center;
        }

        h1 {
            color: #2ecc71;
        }

        .alert {
            color: #ffffff;
            background-color: #e74c3c;
            padding: 10px;
            border-radius: 5px;
            width: 80%;
            margin: 20px auto;
        }

        form {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            display: inline-block;
            width: 300px;
            margin-top: 20px;
        }

        label {
            display: block;
            margin-bottom: 10px;
            font-weight: bold;
        }

        input[type="text"] {
            width: 100%;
            padding: 8px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        button {
            background-color: #2ecc71;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
            width: 100%;
        }

        button:hover {
            background-color: #27ae60;
        }
    </style>
</head>
<body>
    <h1>Find Customer</h1>
    <c:if test="${not empty errorMessage}">
        <div class="alert">${errorMessage}</div>
    </c:if>
    <form id="findCustomerForm" action="${pageContext.request.contextPath}/api/admin/customers/details" method="get">
        <label for="customerId">Customer ID:</label>
        <input type="text" id="customerId" name="id" required>
        <button type="submit">Find</button>
    </form>

    <script>
        function getToken() {
            return localStorage.getItem('adminToken');
        }

        // For GET form, the best pattern with JWT is to redirect with query params,
        // letting Spring Security read Authorization header on the final GET.[web:21][web:30]
        document.getElementById('findCustomerForm').addEventListener('submit', function(e) {
            const token = getToken();
            if (!token) {
                // No JWT → normal behavior (session-based)
                return;
            }

            e.preventDefault();
            const id = document.getElementById('customerId').value.trim();
            if (!id) {
                return;
            }

            // Build target URL with query param
            const baseUrl = this.action; // /context/api/admin/customers/details
            const url = baseUrl + '?id=' + encodeURIComponent(id);

            // Optional: verify token first, then navigate
            fetch(url, {
                method: 'GET',
                headers: {
                    'Authorization': 'Bearer ' + token
                }
            }).then(response => {
                if (response.ok) {
                    // Let browser load the page (Spring MVC) with JWT filter succeeding
                    window.location.href = url;
                } else if (response.status === 401 || response.status === 403) {
                    alert('Session expired. Please login again.');
                    localStorage.removeItem('adminToken');
                    localStorage.removeItem('adminUsername');
                    window.location.href = '${pageContext.request.contextPath}/api/admin/login';
                } else {
                    // For other errors, still redirect so server can show error page
                    window.location.href = url;
                }
            }).catch(() => {
                // On network error, fallback to normal navigation
                window.location.href = url;
            });
        });
    </script>
</body>
</html>
