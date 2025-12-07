<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Loans by Account</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8fafc;
            color: #333;
            margin: 0;
            padding: 20px;
        }

        h1 {
            color: #2e7d32;
            text-align: center;
        }

        table {
            width: 60%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: #ffffff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }

        th {
            background-color: #2e7d32;
            color: #fff;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        a {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #2e7d32;
            text-decoration: none;
            font-weight: bold;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <h1>Loans for Account ID: ${accountId}</h1>
    <table>
        <tr>
            <th>ID</th>
            <th>Amount</th>
            <th>Status</th>
        </tr>
        <c:forEach var="loan" items="${loans}">
            <tr>
                <td>${loan.id}</td>
                <td>${loan.amount}</td>
                <td>${loan.status}</td>
            </tr>
        </c:forEach>
    </table>
    <a href="/admin/loans" onclick="handleNavigation(event, '/admin/loans')">Back to Loan List</a>

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
