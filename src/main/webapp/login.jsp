<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login – HealAt.Home</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">

        <style>
            /* Enhanced modal styles for forgot password popup */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.6);
                backdrop-filter: blur(5px);
                animation: fadeIn 0.3s ease-out;
            }

            .modal-content {
                background-color: var(--white);
                margin: 5% auto;
                padding: 2rem;
                border-radius: var(--radius-xl);
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                width: 90%;
                max-width: 500px;
                position: relative;
                animation: slideIn 0.3s ease-out;
            }

            .close-btn {
                position: absolute;
                right: 1rem;
                top: 1rem;
                font-size: 1.5rem;
                color: var(--text-muted);
                cursor: pointer;
                transition: color 0.3s;
            }

            .close-btn:hover {
                color: var(--error);
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            @keyframes slideIn {
                from {
                    transform: translateY(-50px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }

            /* Username/Email field enhancement */
            .input-group {
                position: relative;
                margin-bottom: var(--space-lg);
            }

            .input-toggle {
                position: absolute;
                right: var(--space-sm);
                top: 50%;
                transform: translateY(-50%);
                background: none;
                border: none;
                color: var(--primary);
                cursor: pointer;
                font-size: 0.9rem;
                font-weight: 600;
                padding: 0.5rem;
                border-radius: var(--radius-md);
                transition: all 0.3s;
            }

            .input-toggle:hover {
                background: rgba(63, 155, 89, 0.1);
            }

            .success-message {
                background: linear-gradient(135deg, #d1fae5, #a7f3d0);
                border: 1px solid #10b981;
                color: #065f46;
                padding: var(--space-lg);
                border-radius: var(--radius-lg);
                margin-bottom: var(--space-lg);
                display: flex;
                align-items: center;
                gap: var(--space-md);
                animation: slideDown 0.5s ease-out;
            }

            @keyframes slideDown {
                from {
                    transform: translateY(-20px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }
        </style>
    </head>
    <body style="background: linear-gradient(135deg, #f0fdf4 0%, var(--white) 50%, #fef7ff 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center;">

        <!-- Floating header for branding -->
        <!-- This creates a fixed positioned brand logo that stays visible during login -->
        <div style="position: fixed; top: var(--space-xl); left: var(--space-xl); z-index: 10;">
            <a href="${pageContext.request.contextPath}/" class="brand" style="text-decoration: none;">
                <i class="fas fa-leaf"></i>
                <h1 style="font-size: 1.5rem;">
                    <span class="brand-first">HealAt.</span>
                    <span class="brand-second-option2">Home</span>
                </h1>
            </a>
        </div>

        <!-- Main login container with enhanced styling -->
        <div class="login-container" style="width: 100%; max-width: 800px; margin: var(--space-xl); position: relative;">

            <!-- Background decoration elements for visual appeal -->
            <div style="position: absolute; top: -50px; left: -50px; width: 100px; height: 100px; background: radial-gradient(circle, rgba(63, 155, 89, 0.1), transparent); border-radius: 50%;"></div>
            <div style="position: absolute; bottom: -30px; right: -30px; width: 60px; height: 60px; background: radial-gradient(circle, rgba(255, 105, 180, 0.1), transparent); border-radius: 50%;"></div>

            <!-- Main login form -->
            <form action="${pageContext.request.contextPath}/login" method="post" class="form animate-fade-in" id="loginForm">

                <!-- Form header with icon and title -->
                <div class="form-header" style="text-align: center; margin-bottom: var(--space-2xl);">
                    <div style="width: 80px; height: 80px; background: linear-gradient(135deg, var(--primary), var(--accent)); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto var(--space-lg); box-shadow: 0 8px 32px rgba(63, 155, 89, 0.3);">
                        <i class="fas fa-user" style="font-size: 2rem; color: white;"></i>
                    </div>
                    <h2 style="font-size: 2rem; font-weight: 800; color: var(--primary-dark); margin-bottom: var(--space-sm);">
                        Welcome Back
                    </h2>
                    <p style="color: var(--text-secondary); font-size: 1.1rem;">
                        Sign in to access your natural remedies
                    </p>
                </div>

                <!-- Success message display (for forgot password confirmation) -->
                <div id="successMessage" class="success-message" style="display: none;">
                    <i class="fas fa-check-circle"></i>
                    <span>Password reset email has been sent to your email address!</span>
                </div>

                <!-- Error message display using JSTL -->
                <c:if test="${not empty error}">
                    <div class="error-message animate-slide-up">
                        <i class="fas fa-exclamation-triangle"></i>
                        <c:out value="${error}"/>
                    </div>
                </c:if>

                <!-- Enhanced email/username input field -->
                <!-- This field can accept both email and username for login flexibility -->
                <label for="loginField">
                    <i class="fas fa-envelope" style="color: var(--primary);"></i>
                    <span id="loginFieldLabel">Email Address or Username</span>
                </label>
                <div class="input-group">
                    <input id="loginField" name="email" type="text" required 
                           placeholder="Enter your email or username"
                           value="<c:out value="${param.email}"/>"
                           autocomplete="email"/>
                    <!-- Toggle button to switch between email and username input modes -->
                    <button type="button" class="input-toggle" id="toggleInputType">
                        Use Username
                    </button>
                </div>

                <!-- Password input field with show/hide functionality -->
                <label for="password">
                    <i class="fas fa-lock" style="color: var(--accent);"></i>
                    Password
                </label>
                <div style="position: relative;">
                    <input id="password" name="password" type="password" required 
                           placeholder="Enter your password"
                           autocomplete="current-password"/>
                    <!-- Button to toggle password visibility -->
                    <button type="button" id="togglePassword" style="position: absolute; right: var(--space-md); top: 50%; transform: translateY(-50%); background: none; border: none; color: var(--text-muted); cursor: pointer; font-size: 1.1rem; transition: color var(--transition-normal);">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>

                <!-- Forgot password link -->
                <div style="text-align: right; margin-top: var(--space-sm); margin-bottom: var(--space-lg);">
                    <a href="#" id="forgotPasswordLink" style="color: var(--primary); text-decoration: none; font-size: 0.95rem; font-weight: 500; transition: color 0.3s;"
                       onmouseover="this.style.color = 'var(--primary-dark)'"
                       onmouseout="this.style.color = 'var(--primary)'">
                        <i class="fas fa-key"></i> Forgot Password?
                    </a>
                </div>

                <!-- Submit button -->
                <div class="form-actions">
                    <button class="btn" type="submit" style="width: 100%; margin-bottom: var(--space-lg);">
                        <i class="fas fa-sign-in-alt"></i> Sign In
                    </button>
                </div>

                <!-- Register link section -->
                <div style="text-align: center; margin-top: var(--space-xl); padding-top: var(--space-xl); border-top: 1px solid var(--border-light);">
                    <p style="color: var(--text-secondary); margin-bottom: var(--space-md);">
                        Don't have an account?
                    </p>
                    <a href="${pageContext.request.contextPath}/register" class="btn outline" style="width: 100%;">
                        <i class="fas fa-user-plus"></i> Create Account
                    </a>
                </div>

                <!-- Back to home link -->
                <div style="text-align: center; margin-top: var(--space-xl);">
                    <a href="${pageContext.request.contextPath}/" style="color: var(--text-muted); text-decoration: none; font-size: 0.95rem; border-bottom: 1px solid transparent; transition: all var(--transition-normal);"
                       onmouseover="this.style.color = 'var(--primary)'; this.style.borderBottomColor = 'var(--primary)'"
                       onmouseout="this.style.color = 'var(--text-muted)'; this.style.borderBottomColor = 'transparent'">
                        <i class="fas fa-arrow-left"></i> Back to Home
                    </a>
                </div>
            </form>
        </div>

        <!-- Forgot Password Modal -->
        <!-- This modal popup allows users to reset their password -->
        <div id="forgotPasswordModal" class="modal">
            <div class="modal-content">
                <!-- Close button for the modal -->
                <span class="close-btn" id="closeModal">&times;</span>

                <!-- Modal header -->
                <div style="text-align: center; margin-bottom: var(--space-xl);">
                    <div style="width: 60px; height: 60px; background: linear-gradient(135deg, var(--accent), var(--secondary)); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto var(--space-md);">
                        <i class="fas fa-key" style="font-size: 1.5rem; color: white;"></i>
                    </div>
                    <h3 style="font-size: 1.5rem; font-weight: 700; color: var(--primary-dark); margin-bottom: var(--space-sm);">
                        Reset Your Password
                    </h3>
                    <p style="color: var(--text-secondary);">
                        Enter your email address and we'll send you a link to reset your password.
                    </p>
                </div>

                <!-- Forgot password form -->
                <form id="forgotPasswordForm">
                    <label for="resetEmail" style="color: var(--text-primary); font-weight: 600; margin-bottom: var(--space-sm); display: block;">
                        <i class="fas fa-envelope" style="color: var(--primary); margin-right: var(--space-sm);"></i>
                        Email Address
                    </label>
                    <input id="resetEmail" name="resetEmail" type="email" required 
                           placeholder="Enter your registered email address"
                           style="width: 100%; padding: var(--space-md); border: 2px solid var(--border-light); border-radius: var(--radius-lg); font-size: 1rem; margin-bottom: var(--space-lg); transition: all 0.3s;"
                           onfocus="this.style.borderColor = 'var(--primary)'; this.style.boxShadow = '0 0 0 4px rgba(63, 155, 89, 0.12)'"
                           onblur="this.style.borderColor = 'var(--border-light)'; this.style.boxShadow = 'none'"/>

                    <!-- Modal action buttons -->
                    <div style="display: flex; gap: var(--space-md); justify-content: flex-end;">
                        <button type="button" id="cancelReset" style="padding: var(--space-md) var(--space-lg); background: var(--gray-100); color: var(--text-secondary); border: none; border-radius: var(--radius-lg); cursor: pointer; transition: all 0.3s;">
                            Cancel
                        </button>
                        <button type="submit" style="padding: var(--space-md) var(--space-xl); background: var(--primary); color: white; border: none; border-radius: var(--radius-lg); cursor: pointer; font-weight: 600; transition: all 0.3s;">
                            <i class="fas fa-paper-plane"></i> Send Reset Link
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            // Password toggle functionality - allows users to show/hide password
            const togglePassword = document.getElementById('togglePassword');
            const passwordInput = document.getElementById('password');

            togglePassword.addEventListener('click', function () {
                // Switch between password and text input types
                const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                passwordInput.setAttribute('type', type);

                // Update the eye icon accordingly
                const icon = this.querySelector('i');
                icon.className = type === 'password' ? 'fas fa-eye' : 'fas fa-eye-slash';
            });

            // Enhanced login field toggle - switches between email and username modes
            const toggleInputType = document.getElementById('toggleInputType');
            const loginField = document.getElementById('loginField');
            const loginFieldLabel = document.getElementById('loginFieldLabel');
            let isEmailMode = true;

            toggleInputType.addEventListener('click', function () {
                if (isEmailMode) {
                    // Switch to username mode
                    loginField.setAttribute('type', 'text');
                    loginField.setAttribute('name', 'username');
                    loginField.setAttribute('placeholder', 'Enter your username');
                    loginField.setAttribute('autocomplete', 'username');
                    loginFieldLabel.innerHTML = '<i class="fas fa-user" style="color: var(--primary);"></i> Username';
                    this.textContent = 'Use Email';
                    isEmailMode = false;
                } else {
                    // Switch back to email mode
                    loginField.setAttribute('type', 'email');
                    loginField.setAttribute('name', 'email');
                    loginField.setAttribute('placeholder', 'Enter your email address');
                    loginField.setAttribute('autocomplete', 'email');
                    loginFieldLabel.innerHTML = '<i class="fas fa-envelope" style="color: var(--primary);"></i> Email Address';
                    this.textContent = 'Use Username';
                    isEmailMode = true;
                }
            });

            // Forgot Password Modal Functionality
            const forgotPasswordModal = document.getElementById('forgotPasswordModal');
            const forgotPasswordLink = document.getElementById('forgotPasswordLink');
            const closeModal = document.getElementById('closeModal');
            const cancelReset = document.getElementById('cancelReset');
            const forgotPasswordForm = document.getElementById('forgotPasswordForm');
            const successMessage = document.getElementById('successMessage');

            // Show modal when "Forgot Password" is clicked
            forgotPasswordLink.addEventListener('click', function (e) {
                e.preventDefault();
                forgotPasswordModal.style.display = 'block';
                document.body.style.overflow = 'hidden'; // Prevent background scrolling
            });

            // Hide modal functions
            function hideModal() {
                forgotPasswordModal.style.display = 'none';
                document.body.style.overflow = 'auto'; // Restore scrolling
                document.getElementById('resetEmail').value = ''; // Clear email field
            }

            // Close modal when X button is clicked
            closeModal.addEventListener('click', hideModal);

            // Close modal when Cancel button is clicked
            cancelReset.addEventListener('click', hideModal);

            // Close modal when clicking outside of it
            window.addEventListener('click', function (e) {
                if (e.target === forgotPasswordModal) {
                    hideModal();
                }
            });

            // Handle forgot password form submission
            forgotPasswordForm.addEventListener('submit', function (e) {
                e.preventDefault();

                const email = document.getElementById('resetEmail').value;
                const submitBtn = this.querySelector('button[type="submit"]');

                console.log('Forgot password form submitted with email:', email);

                // Show loading state
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';
                submitBtn.disabled = true;

                // Prepare form data
                const params = new URLSearchParams();
                params.append('email', email);

                const servletUrl = '${pageContext.request.contextPath}/ForgotPasswordServlet';
                console.log('Sending request to:', servletUrl);

                // Make AJAX request to ForgotPasswordServlet
                fetch(servletUrl, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: params.toString()
                })
                        .then(function (response) {
                            console.log('Response status:', response.status);
                            if (!response.ok) {
                                throw new Error('Server returned status: ' + response.status);
                            }
                            return response.json();
                        })
                        .then(function (data) {
                            console.log('Response data:', data);

                            // Reset button state
                            submitBtn.innerHTML = '<i class="fas fa-paper-plane"></i> Send Reset Link';
                            submitBtn.disabled = false;

                            // Hide modal
                            hideModal();

                            if (data.status === 'ok') {
                                // Show success message
                                successMessage.style.display = 'flex';
                                successMessage.innerHTML = '<i class="fas fa-check-circle"></i><span>' +
                                        (data.message || 'Password reset email has been sent! Please check your inbox and spam folder.') +
                                        '</span>';

                                // Hide success message after 8 seconds
                                setTimeout(function () {
                                    successMessage.style.display = 'none';
                                }, 8000);
                            } else {
                                alert('Error: ' + (data.message || 'Failed to send reset email. Please try again.'));
                            }
                        })
                        .catch(function (error) {
                            console.error('Error:', error);

                            // Reset button state
                            submitBtn.innerHTML = '<i class="fas fa-paper-plane"></i> Send Reset Link';
                            submitBtn.disabled = false;

                            alert('Server error: ' + error.message + '\nPlease check your internet connection and try again.');
                        });
            });

            // Form enhancement for main login form
            const loginForm = document.getElementById('loginForm');
            const submitBtn = loginForm.querySelector('button[type="submit"]');

            loginForm.addEventListener('submit', function (e) {
                // Add loading state to submit button
                submitBtn.classList.add('loading');
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Signing In...';
            });

            // Enhanced focus states for better user experience
            document.querySelectorAll('input').forEach(input => {
                input.addEventListener('focus', function () {
                    this.parentNode.style.transform = 'translateY(-2px)';
                });

                input.addEventListener('blur', function () {
                    this.parentNode.style.transform = 'translateY(0)';
                });
            });

            // Auto-focus on login field when page loads
            document.getElementById('loginField').focus();

            // Keyboard accessibility for modal
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape' && forgotPasswordModal.style.display === 'block') {
                    hideModal();
                }
            });

            // Email validation feedback for forgot password
            const resetEmailInput = document.getElementById('resetEmail');
            resetEmailInput.addEventListener('blur', function () {
                if (this.value && !this.validity.valid) {
                    this.style.borderColor = 'var(--error)';
                } else if (this.value) {
                    this.style.borderColor = 'var(--success)';
                } else {
                    this.style.borderColor = 'var(--border-light)';
                }
            });
        </script>
    </body>
</html>