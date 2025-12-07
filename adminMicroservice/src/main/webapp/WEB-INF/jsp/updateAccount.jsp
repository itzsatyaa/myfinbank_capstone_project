<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Update Account</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f5f2;
            color: #2c3e50;
            margin: 0;
            padding: 20px;
        }

        h2 {
            text-align: center;
            color: #2e7d32;
        }

        .form-container {
            max-width: 500px;
            margin: 30px auto;
            padding: 20px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }

        input[type="text"],
        input[type="number"],
        select {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border-radius: 5px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }

        input[type="submit"] {
            margin-top: 20px;
            background-color: #2e7d32;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        input[type="submit"]:hover {
            background-color: #1b5e20;
        }

        a {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: #2e7d32;
            text-decoration: none;
            font-weight: bold;
        }

        a:hover {
            text-decoration: underline;
        }

        .message {
            text-align: center;
            margin-top: 10px;
        }

        .error {
            color: #e74c3c;
        }

        .success {
            color: #2e7d32;
        }
    </style>
</head>
<body>
<h2>Update Account</h2>

<div class="form-container">
    <div id="messageContainer" class="message"></div>

    <form:form id="updateAccountForm" method="post"
               modelAttribute="accountDTO"
               action="/api/admin/accounts/update/${accountDTO.id}">
        <label for="accountNumber">Account Number:</label>
        <form:input path="accountNumber" id="accountNumber" required="true" /><br/>

        <label for="balance">Balance:</label>
        <form:input path="balance" id="balance" required="true" type="number" step="0.01"/><br/>

        <label for="customerId">Customer:</label>
        <form:select path="customer.id" id="customerId" required="true">
            <c:forEach var="customer" items="${customers}">
                <option value="${customer.id}"
                    <c:if test="${customer.id == accountDTO.customer.id}">selected</c:if>>
                    ${customer.name}
                </option>
            </c:forEach>
        </form:select><br/>

        <input type="submit" value="Update Account" />
    </form:form>

    <a href="/api/admin/accounts/allaccounts"
       onclick="handleNavigation(event, '/api/admin/accounts/allaccounts')">
       Back to Account List
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
            return; // session-based navigation
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

    // Intercept account update submit to send JWT if present
    document.getElementById('updateAccountForm').addEventListener('submit', function(e) {
        const token = getToken();
        if (!token) {
            return; // no JWT, normal Spring MVC post
        }

        e.preventDefault();
        const form = this;
        const url = form.action;
        const formData = new FormData(form);
        const body = new URLSearchParams();
        formData.forEach((value, key) => body.append(key, value));

        fetchWithAuth(url, {
            method: form.method || 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: body.toString()
        }).then(response => {
            const msgDiv = document.getElementById('messageContainer');
            if (response.ok) {
                msgDiv.className = 'message success';
                msgDiv.textContent = 'Account updated successfully.';
                setTimeout(() => {
                    window.location.href = '/api/admin/accounts/allaccounts';
                }, 1000);
            } else if (response.status === 401 || response.status === 403) {
                alert('Session expired. Please login again.');
                localStorage.removeItem('adminToken');
                localStorage.removeItem('adminUsername');
                window.location.href = '/api/admin/login';
            } else {
                msgDiv.className = 'message error';
                msgDiv.textContent = 'Failed to update account. Please try again.';
            }
        }).catch(() => {
            const msgDiv = document.getElementById('messageContainer');
            msgDiv.className = 'message error';
            msgDiv.textContent = 'Failed to update account. Please try again.';
        });
    });

    // Optional: JWT validity check
    window.addEventListener('DOMContentLoaded', function() {
        const token = getToken();
        if (token) {
            fetchWithAuth('/api/admin/dashboard')
                .then(response => {
                    if (!response.ok && response.status === 401) {
                        localStorage.removeItem('adminToken');
                        localStorage.removeItem('adminUsername');
                        window.location.href = '/api/admin/login';
                    }
                });
        }
    });
</script>
</body>
</html>
