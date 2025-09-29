<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - Health@Home</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
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
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            max-width: 480px;
            width: 100%;
            animation: slideIn 0.4s ease-out;
        }
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        .icon-wrapper {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
        }
        .icon-wrapper i {
            color: white;
            font-size: 1.8rem;
        }
        h2 {
            color: #333;
            margin-bottom: 10px;
            font-size: 26px;
            font-weight: 700;
        }
        .subtitle {
            color: #666;
            font-size: 14px;
        }
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
            line-height: 1.5;
        }
        .alert i {
            font-size: 1.2rem;
        }
        .alert.error {
            background-color: #fee;
            color: #c33;
            border-left: 4px solid #c33;
        }
        .alert.success {
            background-color: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }
        .requirements {
            background-color: #e3f2fd;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 25px;
            font-size: 14px;
            border-left: 4px solid #2196F3;
        }
        .requirements strong {
            display: block;
            margin-bottom: 8px;
            color: #1976D2;
        }
        .requirements ul {
            margin: 0;
            padding-left: 20px;
            color: #555;
        }
        .requirements li {
            margin: 5px 0;
        }
        label {
            display: block;
            color: #555;
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 14px;
        }
        label i {
            color: #667eea;
            margin-right: 6px;
        }
        .input-wrapper {
            position: relative;
            margin-bottom: 20px;
        }
        input[type="password"] {
            width: 100%;
            padding: 14px 45px 14px 14px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s;
            font-family: inherit;
        }
        input[type="password"]:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }
        .toggle-password {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #999;
            cursor: pointer;
            font-size: 1.1rem;
            padding: 8px;
            transition: color 0.3s;
        }
        .toggle-password:hover {
            color: #667eea;
        }
        .btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
        }
        .btn:active {
            transform: translateY(0);
        }
        .btn:disabled {
            background: #ccc;
            cursor: not-allowed;
            box-shadow: none;
        }
        .link-wrapper {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        .link-wrapper a {
            color: #667eea;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: color 0.3s;
        }
        .link-wrapper a:hover {
            color: #764ba2;
            text-decoration: underline;
        }
        .password-strength {
            margin-top: 8px;
            font-size: 13px;
            display: none;
        }
        .strength-bar {
            height: 4px;
            background: #eee;
            border-radius: 2px;
            margin-bottom: 5px;
            overflow: hidden;
        }
        .strength-fill {
            height: 100%;
            width: 0%;
            transition: all 0.3s;
            border-radius: 2px;
        }
        .strength-weak { background: #f44336; width: 33%; }
        .strength-medium { background: #ff9800; width: 66%; }
        .strength-strong { background: #4caf50; width: 100%; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="icon-wrapper">
                <i class="fas fa-key"></i>
            </div>
            <h2>Reset Your Password</h2>
            <p class="subtitle">Enter a new password for your account</p>
        </div>

        <% 
            String error = (String) request.getAttribute("error");
            String message = (String) request.getAttribute("message");
            String token = request.getParameter("token");
            if (token == null) {
                token = (String) request.getAttribute("token");
            }
            
            if (error != null) { 
        %>
            <div class="alert error">
                <i class="fas fa-exclamation-circle"></i>
                <span><%= error %></span>
            </div>
        <% 
            }
            if (message != null) { 
        %>
            <div class="alert success">
                <i class="fas fa-check-circle"></i>
                <span><%= message %></span>
            </div>
        <% 
            } 
        %>

        <% if (token == null || token.trim().isEmpty()) { %>
            <div class="alert error">
                <i class="fas fa-exclamation-triangle"></i>
                <span>Invalid reset link. Please request a new password reset.</span>
            </div>
            <div class="link-wrapper">
                <a href="forgotpassword.jsp"><i class="fas fa-arrow-left"></i> Request New Reset Link</a>
            </div>
        <% } else { %>
            <div class="requirements">
                <strong><i class="fas fa-info-circle"></i> Password Requirements:</strong>
                <ul>
                    <li>Minimum 6 characters long</li>
                    <li>Both passwords must match</li>
                </ul>
            </div>

            <form action="ResetPasswordServlet" method="post" id="resetForm">
                <input type="hidden" name="token" value="<%= token %>" />

                <label for="password">
                    <i class="fas fa-lock"></i>
                    New Password
                </label>
                <div class="input-wrapper">
                    <input type="password" name="password" id="password" 
                           required minlength="6" 
                           placeholder="Enter new password" />
                    <button type="button" class="toggle-password" data-target="password">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>
                <div class="password-strength" id="strength">
                    <div class="strength-bar">
                        <div class="strength-fill" id="strengthFill"></div>
                    </div>
                    <span id="strengthText"></span>
                </div>

                <label for="confirmPassword">
                    <i class="fas fa-lock"></i>
                    Confirm Password
                </label>
                <div class="input-wrapper">
                    <input type="password" name="confirmPassword" id="confirmPassword" 
                           required minlength="6" 
                           placeholder="Confirm new password" />
                    <button type="button" class="toggle-password" data-target="confirmPassword">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>

                <button type="submit" class="btn">
                    <i class="fas fa-check"></i> Reset Password
                </button>
            </form>

            <div class="link-wrapper">
                <a href="login.jsp"><i class="fas fa-arrow-left"></i> Back to Login</a>
            </div>
        <% } %>
    </div>

    <script>
        // Password visibility toggle
        document.querySelectorAll('.toggle-password').forEach(button => {
            button.addEventListener('click', function() {
                const targetId = this.getAttribute('data-target');
                const input = document.getElementById(targetId);
                const icon = this.querySelector('i');
                
                if (input.type === 'password') {
                    input.type = 'text';
                    icon.classList.remove('fa-eye');
                    icon.classList.add('fa-eye-slash');
                } else {
                    input.type = 'password';
                    icon.classList.remove('fa-eye-slash');
                    icon.classList.add('fa-eye');
                }
            });
        });

        // Password strength indicator
        const passwordInput = document.getElementById('password');
        const strengthDiv = document.getElementById('strength');
        const strengthFill = document.getElementById('strengthFill');
        const strengthText = document.getElementById('strengthText');

        passwordInput.addEventListener('input', function() {
            const password = this.value;
            
            if (password.length === 0) {
                strengthDiv.style.display = 'none';
                return;
            }
            
            strengthDiv.style.display = 'block';
            
            let strength = 0;
            if (password.length >= 6) strength++;
            if (password.length >= 10) strength++;
            if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
            if (/\d/.test(password)) strength++;
            if (/[^a-zA-Z\d]/.test(password)) strength++;
            
            strengthFill.className = 'strength-fill';
            
            if (strength <= 2) {
                strengthFill.classList.add('strength-weak');
                strengthText.textContent = 'Weak password';
                strengthText.style.color = '#f44336';
            } else if (strength <= 3) {
                strengthFill.classList.add('strength-medium');
                strengthText.textContent = 'Medium strength';
                strengthText.style.color = '#ff9800';
            } else {
                strengthFill.classList.add('strength-strong');
                strengthText.textContent = 'Strong password';
                strengthText.style.color = '#4caf50';
            }
        });

        // Form validation
        document.getElementById('resetForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirm = document.getElementById('confirmPassword').value;
            
            if (password !== confirm) {
                e.preventDefault();
                alert('Passwords do not match!');
                return false;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                alert('Password must be at least 6 characters long!');
                return false;
            }
            
            // Show loading state
            const btn = this.querySelector('button[type="submit"]');
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Resetting Password...';
            btn.disabled = true;
        });
    </script>
</body>
</html>