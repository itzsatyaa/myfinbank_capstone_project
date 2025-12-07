<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.myfinbank.admin.dto.LoanDTO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Loan Management - MyFinBank Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* existing CSS unchanged */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8fafc;
            color: #333;
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
        nav ul { list-style: none; display: flex; margin: 0; padding: 0; }
        nav ul li { margin-right: 20px; }
        nav ul li a {
            color: white;
            text-decoration: none;
            padding: 10px 15px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        nav ul li a:hover { background-color: #1b5e20; }

        .container {
            max-width: 1400px;
            margin: 40px auto;
            padding: 0 20px;
        }

        h1 {
            color: #2e7d32;
            text-align: center;
            margin-bottom: 30px;
            font-size: 32px;
        }

        .filter-section {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 30px;
        }

        .filter-button {
            padding: 10px 20px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s;
            background: #e0e0e0;
            color: #333;
        }

        .filter-button.active, .filter-button:hover {
            background: #2e7d32;
            color: white;
            transform: scale(1.05);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        thead {
            background-color: #2e7d32;
            color: white;
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }

        th {
            font-weight: 600;
            text-transform: uppercase;
            font-size: 13px;
            letter-spacing: 0.5px;
        }

        tr:hover {
            background-color: #f5f5f5;
        }

        .status-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }

        .status-approved {
            background-color: #d4edda;
            color: #155724;
        }

        .status-rejected {
            background-color: #f8d7da;
            color: #721c24;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-approve {
            background-color: #28a745;
            color: white;
        }

        .btn-approve:hover {
            background-color: #218838;
            transform: scale(1.05);
        }

        .btn-reject {
            background-color: #dc3545;
            color: white;
        }

        .btn-reject:hover {
            background-color: #c82333;
            transform: scale(1.05);
        }

        .btn-view {
            background-color: #007bff;
            color: white;
        }

        .btn-view:hover {
            background-color: #0056b3;
        }

        .no-loans {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .no-loans i {
            font-size: 64px;
            margin-bottom: 20px;
            display: block;
            opacity: 0.5;
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            animation: fadeIn 0.3s;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .modal-content {
            background-color: white;
            margin: 10% auto;
            padding: 30px;
            border-radius: 10px;
            width: 500px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
            animation: slideDown 0.3s;
        }

        @keyframes slideDown {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .modal-header h2 {
            margin: 0;
            color: #2e7d32;
        }

        .close {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            transition: color 0.3s;
        }

        .close:hover {
            color: #000;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        .form-group input, .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 25px;
        }

        .btn-cancel {
            background-color: #6c757d;
            color: white;
        }

        .btn-cancel:hover {
            background-color: #5a6268;
        }

        .btn-submit {
            background-color: #2e7d32;
            color: white;
            padding: 10px 25px;
        }

        .btn-submit:hover {
            background-color: #1b5e20;
        }
    </style>
</head>
<body>
    <nav>
        <h2>MyFinBank Admin</h2>
        <ul>
            <li><a href="/api/admin/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li><a href="/api/admin/customers"><i class="fas fa-users"></i> Customers</a></li>
            <li><a href="/api/admin/accounts"><i class="fas fa-list"></i> Accounts</a></li>
            <li><a href="/api/admin/loans"><i class="fas fa-money-bill"></i> Loans</a></li>
        </ul>
    </nav>

    <div class="container">
        <h1><i class="fas fa-hand-holding-usd"></i> Loan Management</h1>

        <!-- Filter Buttons -->
        <div class="filter-section">
            <button class="filter-button active" onclick="filterLoans(event, 'ALL')">
                <i class="fas fa-list"></i> All Loans (<%= ((List<LoanDTO>) request.getAttribute("loans")).size() %>)
            </button>
            <button class="filter-button" onclick="filterLoans(event, 'PENDING')">
                <i class="fas fa-clock"></i> Pending
            </button>
            <button class="filter-button" onclick="filterLoans(event, 'APPROVED')">
                <i class="fas fa-check-circle"></i> Approved
            </button>
            <button class="filter-button" onclick="filterLoans(event, 'REJECTED')">
                <i class="fas fa-times-circle"></i> Rejected
            </button>
        </div>

        <% 
            List<LoanDTO> loans = (List<LoanDTO>) request.getAttribute("loans");
            if (loans != null && !loans.isEmpty()) { 
        %>
        <table id="loanTable">
            <thead>
                <tr>
                    <th>Loan ID</th>
                    <th>Customer Name</th>
                    <th>Customer Email</th>
                    <th>Loan Type</th>
                    <th>Amount (₹)</th>
                    <th>Tenure</th>
                    <th>Interest Rate</th>
                    <th>Applied Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% for (LoanDTO loan : loans) { %>
                <tr data-status="<%= loan.getStatus() %>">
                    <td><strong>#<%= loan.getId() %></strong></td>
                    <td><%= loan.getCustomerName() %></td>
                    <td><%= loan.getCustomerEmail() %></td>
                    <td><%= loan.getLoanType() %></td>
                    <td>₹<%= String.format("%,.2f", loan.getLoanAmount()) %></td>
                    <td><%= loan.getTenureMonths() %> months</td>
                    <td><%= loan.getInterestRate() != null ? loan.getInterestRate() + "%" : "-" %></td>
                    <td><%= loan.getAppliedDate() != null ? loan.getAppliedDate().toString().substring(0, 10) : "-" %></td>
                    <td>
                        <span class="status-badge status-<%= loan.getStatus().toLowerCase() %>">
                            <%= loan.getStatus() %>
                        </span>
                    </td>
                    <td>
                        <div class="action-buttons">
                            <% if ("PENDING".equals(loan.getStatus())) { %>
                                <button class="btn btn-approve" onclick="openApproveModal(<%= loan.getId() %>, '<%= loan.getCustomerName() %>', <%= loan.getLoanAmount() %>)">
                                    <i class="fas fa-check"></i> Approve
                                </button>
                                <button class="btn btn-reject" onclick="openRejectModal(<%= loan.getId() %>, '<%= loan.getCustomerName() %>')">
                                    <i class="fas fa-times"></i> Reject
                                </button>
                            <% } else { %>
                                <span style="color: #999; font-style: italic;">
                                    <%= "APPROVED".equals(loan.getStatus()) ? "✅ Approved" : "❌ Rejected" %>
                                </span>
                            <% } %>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } else { %>
        <div class="no-loans">
            <i class="fas fa-inbox"></i>
            <h2>No Loan Applications Found</h2>
            <p>There are currently no loan applications to display.</p>
        </div>
        <% } %>
    </div>

    <!-- Approve Modal -->
    <div id="approveModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2><i class="fas fa-check-circle" style="color: #28a745;"></i> Approve Loan</h2>
                <span class="close" onclick="closeModal('approveModal')">&times;</span>
            </div>
            <form id="approveForm" method="POST" onsubmit="return submitWithAuth(event, this);">
                <p id="approveLoanInfo" style="margin-bottom: 20px; color: #666;"></p>
                <div class="form-group">
                    <label for="interestRate">Interest Rate (%) *</label>
                    <input type="number" id="interestRate" name="interestRate" 
                           step="0.1" min="1" max="25" required 
                           placeholder="e.g., 8.5">
                </div>
                <div class="form-group">
                    <label for="approveRemarks">Remarks (Optional)</label>
                    <textarea id="approveRemarks" name="remarks" 
                              placeholder="Add any additional comments..."></textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" onclick="closeModal('approveModal')">Cancel</button>
                    <button type="submit" class="btn btn-submit">
                        <i class="fas fa-check"></i> Approve Loan
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Reject Modal -->
    <div id="rejectModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2><i class="fas fa-times-circle" style="color: #dc3545;"></i> Reject Loan</h2>
                <span class="close" onclick="closeModal('rejectModal')">&times;</span>
            </div>
            <form id="rejectForm" method="POST" onsubmit="return submitWithAuth(event, this);">
                <p id="rejectLoanInfo" style="margin-bottom: 20px; color: #666;"></p>
                <div class="form-group">
                    <label for="rejectRemarks">Rejection Reason *</label>
                    <textarea id="rejectRemarks" name="remarks" required 
                              placeholder="Please provide a reason for rejection..."></textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" onclick="closeModal('rejectModal')">Cancel</button>
                    <button type="submit" class="btn btn-reject">
                        <i class="fas fa-times"></i> Reject Loan
                    </button>
                </div>
            </form>
        </div>
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

        function filterLoans(event, status) {
            const rows = document.querySelectorAll('#loanTable tbody tr');
            const buttons = document.querySelectorAll('.filter-button');
            
            buttons.forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');
            
            rows.forEach(row => {
                if (status === 'ALL' || row.dataset.status === status) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        function openApproveModal(loanId, customerName, amount) {
            document.getElementById('approveLoanInfo').innerHTML =
                `Approving loan <strong>#${loanId}</strong> for <strong>${customerName}</strong> (₹${amount.toLocaleString('en-IN', {minimumFractionDigits: 2})})`;

            document.getElementById('approveForm').action =
                '<%= request.getContextPath() %>/api/admin/loans/' + loanId + '/approve';

            document.getElementById('approveModal').style.display = 'block';
        }

        function openRejectModal(loanId, customerName) {
            document.getElementById('rejectLoanInfo').innerHTML =
                `Rejecting loan <strong>#${loanId}</strong> for <strong>${customerName}</strong>`;

            document.getElementById('rejectForm').action =
                '<%= request.getContextPath() %>/api/admin/loans/' + loanId + '/reject';

            document.getElementById('rejectModal').style.display = 'block';
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }

        window.onclick = function(event) {
            if (event.target.classList.contains('modal')) {
                event.target.style.display = 'none';
            }
        }

        // Submit approve/reject with JWT if available, else normal POST
        function submitWithAuth(event, form) {
            const token = getToken();
            if (!token) {
                return true; // session-based flow
            }

            event.preventDefault();
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
                if (response.ok) {
                    // Reload page to see updated loan status
                    window.location.reload();
                } else if (response.status === 401 || response.status === 403) {
                    alert('Session expired. Please login again.');
                    localStorage.removeItem('adminToken');
                    localStorage.removeItem('adminUsername');
                    window.location.href = '<%= request.getContextPath() %>/api/admin/login';
                } else {
                    alert('Operation failed. Please try again.');
                }
            }).catch(() => {
                alert('Operation failed. Please try again.');
            });

            return false;
        }

        // Optional JWT validity check on load
        window.addEventListener('DOMContentLoaded', function() {
            const token = getToken();
            if (token) {
                fetchWithAuth('<%= request.getContextPath() %>/api/admin/dashboard')
                    .then(response => {
                        if (!response.ok && response.status === 401) {
                            localStorage.removeItem('adminToken');
                            localStorage.removeItem('adminUsername');
                            window.location.href = '<%= request.getContextPath() %>/api/admin/login';
                        }
                    });
            }
        });
    </script>
</body>
</html>
