<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — HealAt.Home</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
</head>
<body style="background: linear-gradient(135deg, #f0fdf4 0%, var(--white) 50%, #fef7ff 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center;">
    
    <!-- Floating header for branding -->
    <div style="position: fixed; top: var(--space-xl); left: var(--space-xl); z-index: 10;">
        <a href="${pageContext.request.contextPath}/" class="brand" style="text-decoration: none;">
            <i class="fas fa-leaf"></i>
            <h1 style="font-size: 1.5rem;">
                <span class="brand-first">HealAt.</span>
                <span class="brand-second-option2">Home</span>
            </h1>
        </a>
    </div>

    <div class="register-container" style="width: 100%; max-width: 800px; margin: var(--space-xl); position: relative;">
        
        <!-- Background decoration -->
        <div style="position: absolute; top: -50px; left: -50px; width: 100px; height: 100px; background: radial-gradient(circle, rgba(63, 155, 89, 0.1), transparent); border-radius: 50%;"></div>
        <div style="position: absolute; bottom: -30px; right: -30px; width: 60px; height: 60px; background: radial-gradient(circle, rgba(255, 105, 180, 0.1), transparent); border-radius: 50%;"></div>

        <form action="${pageContext.request.contextPath}/register" method="post" class="form animate-fade-in" id="registerForm">
            <div class="form-header" style="text-align: center; margin-bottom: var(--space-2xl);">
                <div style="width: 80px; height: 80px; background: linear-gradient(135deg, var(--accent), var(--secondary)); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto var(--space-lg); box-shadow: 0 8px 32px rgba(63, 155, 89, 0.3);">
                    <i class="fas fa-user-plus" style="font-size: 2rem; color: white;"></i>
                </div>
                <h2 style="font-size: 2rem; font-weight: 800; color: var(--primary-dark); margin-bottom: var(--space-sm);">
                    Register
                </h2>
            </div>

            <c:if test="${not empty error}">
                <div class="error-message animate-slide-up">
                    <i class="fas fa-exclamation-triangle"></i>
                    <c:out value="${error}"/>
                </div>
            </c:if>

            <label for="name">
                <i class="fas fa-user" style="color: var(--primary);"></i>
                User Name
            </label>
            <input id="name" name="name" type="text" required 
                   placeholder="Enter your full name"
                   value="<c:out value="${param.name}"/>"
                   autocomplete="name"
                   minlength="2" maxlength="50"/>

            <label for="email">
                <i class="fas fa-envelope" style="color: var(--accent);"></i>
                Email Address
            </label>
            <input id="email" name="email" type="email" required 
                   placeholder="Enter your email address"
                   value="<c:out value="${param.email}"/>"
                   autocomplete="email"/>

            <label for="password">
                <i class="fas fa-lock" style="color: var(--secondary);"></i>
                Password
            </label>
            <div style="position: relative;">
                <input id="password" name="password" type="password" required 
                       placeholder="Create a secure password"
                       autocomplete="new-password"
                       minlength="6"/>
                <button type="button" id="togglePassword" style="position: absolute; right: var(--space-md); top: 50%; transform: translateY(-50%); background: none; border: none; color: var(--text-muted); cursor: pointer; font-size: 1.1rem; transition: color var(--transition-normal);">
                    <i class="fas fa-eye"></i>
                </button>
            </div>
            
            <!-- Password strength indicator -->
            <div id="passwordStrength" style="margin-top: var(--space-sm); display: none;">
                <!-- <div style="display: flex; gap: 2px; margin-bottom: var(--space-xs);">
                    <div class="strength-bar" style="flex: 1; height: 4px; background: var(--border-light); border-radius: 2px;"></div>
                    <div class="strength-bar" style="flex: 1; height: 4px; background: var(--border-light); border-radius: 2px;"></div>
                    <div class="strength-bar" style="flex: 1; height: 4px; background: var(--border-light); border-radius: 2px;"></div>
                    <div class="strength-bar" style="flex: 1; height: 4px; background: var(--border-light); border-radius: 2px;"></div>
                </div>
                <small id="strengthText" style="color: var(--text-muted);">Password strength</small> -->
            </div>

            <div class="form-actions">
                <button class="btn" type="submit" style="width: 100%; margin-bottom: var(--space-lg);">
                    <i class="fas fa-user-plus"></i> Create Account
                </button>
            </div>

            <div style="text-align: center; margin-top: var(--space-xl); padding-top: var(--space-xl); border-top: 1px solid var(--border-light);">
                <p style="color: var(--text-secondary); margin-bottom: var(--space-md);">
                    Already have an account?
                </p>
                <a href="${pageContext.request.contextPath}/login" class="btn outline" style="width: 100%;">
                    <i class="fas fa-sign-in-alt"></i> Sign In
                </a>
            </div>

            <div style="text-align: center; margin-top: var(--space-xl);">
                <a href="${pageContext.request.contextPath}/" style="color: var(--text-muted); text-decoration: none; font-size: 0.95rem; border-bottom: 1px solid transparent; transition: all var(--transition-normal);"
                   onmouseover="this.style.color='var(--primary)'; this.style.borderBottomColor='var(--primary)'"
                   onmouseout="this.style.color='var(--text-muted)'; this.style.borderBottomColor='transparent'">
                    <i class="fas fa-arrow-left"></i> Back to Home
                </a>
            </div>
        </form>
    </div>

    <script>
        // Password toggle functionality
        const togglePassword = document.getElementById('togglePassword');
        const passwordInput = document.getElementById('password');
        
        togglePassword.addEventListener('click', function() {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            
            const icon = this.querySelector('i');
            icon.className = type === 'password' ? 'fas fa-eye' : 'fas fa-eye-slash';
        });

        // Password strength checker
        const strengthIndicator = document.getElementById('passwordStrength');
        const strengthBars = document.querySelectorAll('.strength-bar');
        const strengthText = document.getElementById('strengthText');
        
        passwordInput.addEventListener('input', function() {
            const password = this.value;
            const strength = calculatePasswordStrength(password);
            
            if (password.length > 0) {
                strengthIndicator.style.display = 'block';
                updateStrengthIndicator(strength);
            } else {
                strengthIndicator.style.display = 'none';
            }
        });
        
        function calculatePasswordStrength(password) {
            let score = 0;
            if (password.length >= 6) score++;
            if (password.length >= 10) score++;
            if (/[A-Z]/.test(password)) score++;
            if (/[0-9]/.test(password)) score++;
            if (/[^A-Za-z0-9]/.test(password)) score++;
            return Math.min(score, 4);
        }
        
        function updateStrengthIndicator(strength) {
            const colors = ['#ef4444', '#f97316', '#eab308', '#10b981'];
            const texts = ['Weak', 'Fair', 'Good', 'Strong'];
            
            strengthBars.forEach((bar, index) => {
                bar.style.background = index < strength ? colors[strength - 1] : 'var(--border-light)';
            });
            
            if (strength > 0) {
                strengthText.textContent = texts[strength - 1];
                strengthText.style.color = colors[strength - 1];
            }
        }

        // Form validation and submission
        const form = document.getElementById('registerForm');
        const submitBtn = form.querySelector('button[type="submit"]');
        
        form.addEventListener('submit', function(e) {
            const password = passwordInput.value;
            if (password.length < 6) {
                e.preventDefault();
                alert('Password must be at least 6 characters long');
                return;
            }
            
            submitBtn.classList.add('loading');
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating Account...';
        });

        // Enhanced focus states
        document.querySelectorAll('input').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentNode.style.transform = 'translateY(-2px)';
            });
            
            input.addEventListener('blur', function() {
                this.parentNode.style.transform = 'translateY(0)';
            });
        });

        // Auto-focus name field
        document.getElementById('name').focus();

        // Real-time validation feedback
        const emailInput = document.getElementById('email');
        emailInput.addEventListener('blur', function() {
            if (this.value && !this.validity.valid) {
                this.style.borderColor = 'var(--error)';
            } else if (this.value) {
                this.style.borderColor = 'var(--success)';
            }
        });

        const nameInput = document.getElementById('name');
        nameInput.addEventListener('input', function() {
            if (this.value.length >= 2) {
                this.style.borderColor = 'var(--success)';
            } else if (this.value.length > 0) {
                this.style.borderColor = 'var(--warning)';
            }
        });
    </script>
</body>
</html>