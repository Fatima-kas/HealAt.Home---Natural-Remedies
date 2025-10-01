<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - HealAt.Home</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
</head>
<body style="min-height: 100vh; display: flex; align-items: center; justify-content: center; background: linear-gradient(135deg, #f0fdf4 0%, #ffffff 50%, #fef7ff 100%);">
    
    <!-- Brand Header -->
    <div style="position: absolute; top: var(--space-xl); left: var(--space-xl);">
        <a href="${pageContext.request.contextPath}/" class="brand" style="text-decoration: none;">
            <i class="fas fa-leaf"></i>
            <h1 style="display: inline; margin-left: var(--space-sm);">
                <span class="brand-first">HealAt.</span>
                <span class="brand-second-option2">Home</span>
            </h1>
        </a>
    </div>

    <!-- Reset Password Container -->
    <div style="background: rgba(255, 255, 255, 0.95); border: 1px solid var(--border-light); border-radius: var(--radius-2xl); padding: var(--space-3xl); box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1); backdrop-filter: blur(20px); max-width: 480px; width: 90%; margin: var(--space-3xl) auto; animation: fadeIn 0.6s ease-out;">
        
        <!-- Header -->
        <div style="text-align: center; margin-bottom: var(--space-2xl);">
            <div style="width: 70px; height: 70px; background: linear-gradient(135deg, var(--primary), var(--primary-dark)); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto var(--space-lg); box-shadow: 0 8px 20px rgba(63, 155, 89, 0.4);">
                <i class="fas fa-key" style="color: white; font-size: 1.8rem;"></i>
            </div>
            <h2 style="margin-bottom: var(--space-sm);">Reset Your Password</h2>
            <p style="color: var(--text-secondary); font-size: var(--font-size-sm); margin: 0;">Enter your new password below</p>
        </div>

        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="error-message" style="margin-bottom: var(--space-lg);">
                <i class="fas fa-exclamation-circle"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <!-- Success Message -->
        <c:if test="${not empty message}">
            <div class="success-message" style="margin-bottom: var(--space-lg);">
                <i class="fas fa-check-circle"></i>
                <span>${message}</span>
            </div>
        </c:if>

        <!-- Requirements Box -->
        <div style="background: linear-gradient(135deg, #e3f2fd, #bbdefb); border-left: 4px solid var(--secondary); padding: var(--space-lg); border-radius: var(--radius-lg); margin-bottom: var(--space-xl);">
            <strong style="display: flex; align-items: center; gap: var(--space-sm); color: var(--primary-dark); margin-bottom: var(--space-sm); font-size: var(--font-size-sm);">
                <i class="fas fa-info-circle"></i> Password Requirements:
            </strong>
            <ul style="margin: 0; padding-left: var(--space-xl); color: var(--text-secondary); font-size: var(--font-size-sm); line-height: 1.7;">
                <li>At least 6 characters long</li>
                <li>Both passwords must match</li>
            </ul>
        </div>

        <!-- Reset Form -->
        <form action="${pageContext.request.contextPath}/ResetPasswordServlet" method="post">
            <input type="hidden" name="token" value="${param.token}">
            
            <!-- New Password -->
            <label for="password">
                <i class="fas fa-lock"></i> New Password
            </label>
            <div style="position: relative; margin-bottom: var(--space-lg);">
                <input 
                    type="password" 
                    id="password" 
                    name="password" 
                    placeholder="Enter new password"
                    required
                    minlength="6"
                    style="padding-right: 45px;"
                />
                <button 
                    type="button" 
                    onclick="togglePassword('password', this)"
                    style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%); background: none; border: none; color: var(--gray-400); cursor: pointer; font-size: 1.1rem; padding: var(--space-sm); transition: color var(--transition-normal);"
                    onmouseover="this.style.color='var(--primary)'"
                    onmouseout="this.style.color='var(--gray-400)'"
                >
                    <i class="fas fa-eye"></i>
                </button>
            </div>

            <!-- Confirm Password -->
            <label for="confirmPassword">
                <i class="fas fa-lock"></i> Confirm Password
            </label>
            <div style="position: relative; margin-bottom: var(--space-xl);">
                <input 
                    type="password" 
                    id="confirmPassword" 
                    name="confirmPassword" 
                    placeholder="Confirm new password"
                    required
                    minlength="6"
                    style="padding-right: 45px;"
                />
                <button 
                    type="button" 
                    onclick="togglePassword('confirmPassword', this)"
                    style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%); background: none; border: none; color: var(--gray-400); cursor: pointer; font-size: 1.1rem; padding: var(--space-sm); transition: color var(--transition-normal);"
                    onmouseover="this.style.color='var(--primary)'"
                    onmouseout="this.style.color='var(--gray-400)'"
                >
                    <i class="fas fa-eye"></i>
                </button>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn" style="width: 100%; justify-content: center;">
                <i class="fas fa-check"></i> Reset Password
            </button>
        </form>

        <!-- Back to Login Link -->
        <div style="text-align: center; margin-top: var(--space-xl); padding-top: var(--space-lg); border-top: 1px solid var(--border-light);">
            <a href="${pageContext.request.contextPath}/login" style="color: var(--primary); text-decoration: none; font-size: var(--font-size-sm); font-weight: 500; display: inline-flex; align-items: center; gap: var(--space-xs); transition: all var(--transition-normal);">
                <i class="fas fa-arrow-left"></i> Back to Login
            </a>
        </div>
    </div>

    <script>
        function togglePassword(fieldId, button) {
            const field = document.getElementById(fieldId);
            const icon = button.querySelector('i');
            
            if (field.type === 'password') {
                field.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                field.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }

        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match. Please try again.');
                return false;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                alert('Password must be at least 6 characters long.');
                return false;
            }
        });
    </script>
</body>
</html>