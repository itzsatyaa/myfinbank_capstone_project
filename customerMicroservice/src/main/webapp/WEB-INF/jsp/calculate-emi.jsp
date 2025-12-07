<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>  
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Loan EMI Calculator</title>
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

        .container {
            width: 400px;
            background-color: #27ae60; /* Green background */
            display: flex;
            flex-direction: column;
            justify-content: flex-start; 
            align-items: flex-start;    
            padding: 30px;  
            border-radius: 10px;
            color: white;
            margin: 100px auto; 
        }

        h1 {
            color: white;
            align-self: center; 
            margin-bottom: 20px; 
        }

        p {
            color: white;
            font-size: 20px;
            width: 100%;
            margin-bottom: 15px; 
        }

        input {
            height: 33px;
            width: 100%;
            background-color: white;
            font-size: 20px;
            color: #031926;
            padding: 7px;
            margin-top: 5px; 
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        #btn {
            background-color: #1e8449; /* Darker green for button */
            color: white;
            width: 100%;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 20px; 
            align-self: center; 
            transition: background-color 0.3s;
        }

        #btn:hover {
            background-color: #196f3d; /* Darker shade on hover */
        }

        span {
            font-weight: bold; 
            color: white;
        }

        ::placeholder {
            color: #031926;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Loan EMI Calculator</h1>
        <p>Loan amount: Rs.
            <input type="number" id="amount" placeholder="Enter amount">
        </p>
        <p>Rate (Interest): %
            <input step=".1" id="rate" placeholder="Enter rate">
        </p>
        <p>Months (Time):
            <input type="number" id="time" placeholder="Enter time">
        </p>
        <input type="button" value="Calculate" id="btn" onclick="calculate()">
        <p>Monthly EMI: Rs.
            <span id="output"></span>
        </p>
    </div>
    <script>
        function calculate() {
            let amount = document.getElementById('amount').value;
            let rate = document.getElementById('rate').value;
            let time = document.getElementById('time').value;
            let monthlyRate = rate / 12 / 100;
            let emi = (amount * monthlyRate * Math.pow(1 + monthlyRate, time)) / 
                      (Math.pow(1 + monthlyRate, time) - 1);
            let result = emi.toFixed(2);
            document.getElementById("output").innerHTML = result;
        }
    </script>
</body>
</html>
