<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - Health@Home</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .container {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            max-width: 450px;
            width: 100%;
        }
        h2 {
            color: #333;
            margin-bottom: 10px;
            font-size: 28px;
        }
        .subtitle {
            color: #666;
            margin-bottom: 30px;
            font-size: 14px;
        }
        label {
            display: block;
            color: #555;
            font-weight: 600;
            margin-bottom: 8px;
        }
        input[type="email"] {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        input[type="email"]:focus {
            outline: none;
            border-color: #667eea;
        }
        button {
            width: 100%;
            padding: 14px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 20px;
            transition: background 0.3s;
        }
        button:hover {
            background: #5568d3;
        }
        button:disabled {
            background: #ccc;
            cursor: not-allowed;
        }
        #msg {
            margin-top: 20px;
            padding: 15px;
            border-radius: 6px;
            display: none;
            font-size: 14px;
            line-height: 1.6;
        }
        #msg.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
            display: block;
        }
        #msg.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
            display: block;
        }
        .loading {
            display: none;
            text-align: center;
            margin-top: 15px;
        }
        .loading.active {
            display: block;
        }
        .spinner {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #667eea;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            animation: spin 1s linear infinite;
            margin: 0 auto;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .back-link {
            text-align: center;
            margin-top: 20px;
        }
        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-size: 14px;
        }
        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>🔐 Forgot Password?</h2>
        <p class="subtitle">Enter your email address and we'll send you a link to reset your password.</p>

        <form id="forgotForm">
            <label for="email">Email Address</label>
            <input 
                type="email" 
                name="email" 
                id="email" 
                placeholder="your-email@example.com"
                required 
                autocomplete="email"
            />
            
            <button type="submit" id="submitBtn">Send Reset Link</button>
        </form>

        <div class="loading" id="loading">
            <div class="spinner"></div>
            <p style="margin-top: 10px; color: #666;">Sending email...</p>
        </div>

        <div id="msg"></div>

        <div class="back-link">
            <a href="login.jsp">← Back to Login</a>
        </div>
    </div>

    <script>
        console.log('Forgot Password Page Loaded');
        console.log('Context Path:', '<%= request.getContextPath() %>');
        
        document.getElementById('forgotForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            var email = document.getElementById('email').value.trim();
            var submitBtn = document.getElementById('submitBtn');
            var loading = document.getElementById('loading');
            var msgDiv = document.getElementById('msg');
            
            console.log('Form submitted with email:', email);
            
            // Validate email
            if (!email) {
                showMessage('Please enter your email address', 'error');
                return;
            }
            
            // Basic email validation
            var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                showMessage('Please enter a valid email address', 'error');
                return;
            }
            
            // Disable button and show loading
            submitBtn.disabled = true;
            submitBtn.textContent = 'Sending...';
            loading.classList.add('active');
            msgDiv.style.display = 'none';
            
            // Prepare form data
            var params = new URLSearchParams();
            params.append('email', email);
            
            var servletUrl = '<%= request.getContextPath() %>/ForgotPasswordServlet';
            console.log('Sending request to:', servletUrl);
            
            fetch(servletUrl, {
                method: 'POST',
                headers: { 
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params.toString()
            })
            .then(function(response) {
                console.log('Response status:', response.status);
                console.log('Response ok:', response.ok);
                
                if (!response.ok) {
                    throw new Error('Server returned status: ' + response.status);
                }
                
                return response.json();
            })
            .then(function(data) {
                console.log('Response data:', data);
                
                // Hide loading
                loading.classList.remove('active');
                submitBtn.disabled = false;
                submitBtn.textContent = 'Send Reset Link';
                
                if (data.status === 'ok') {
                    showMessage(data.message || 'Reset link sent! Please check your email (and spam folder).', 'success');
                    // Clear the form
                    document.getElementById('email').value = '';
                } else {
                    showMessage(data.message || 'An error occurred. Please try again.', 'error');
                }
            })
            .catch(function(error) {
                console.error('Error:', error);
                
                // Hide loading
                loading.classList.remove('active');
                submitBtn.disabled = false;
                submitBtn.textContent = 'Send Reset Link';
                
                showMessage('Server error. Please check the console and try again. Error: ' + error.message, 'error');
            });
        });
        
        function showMessage(message, type) {
            var msgDiv = document.getElementById('msg');
            msgDiv.textContent = message;
            msgDiv.className = type;
            msgDiv.style.display = 'block';
            
            console.log('Message displayed:', type, message);
        }
    </script>
</body>
</html>