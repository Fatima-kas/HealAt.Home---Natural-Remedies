<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add Remedy — HealAt.Home</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    </head>
    <body>
        <header class="site-header" id="header">
            <div class="container">
                <a href="${pageContext.request.contextPath}/" class="brand">
                    <i class="fas fa-leaf"></i>
                    <h1>
                        <span class="brand-first">HealAt.</span>
                        <span class="brand-second-option2">Home</span>
                    </h1>
                </a>

                <nav class="nav" id="mainNav">
                    <a href="${pageContext.request.contextPath}/">
                        <i class="fas fa-home"></i> Home
                    </a>
                    <a href="${pageContext.request.contextPath}/search">
                        <i class="fas fa-search"></i> Search
                    </a>
                    <a href="${pageContext.request.contextPath}/addRemedy" class="active">
                        <i class="fas fa-plus-circle"></i> Add Remedy
                    </a>
                    <a href="${pageContext.request.contextPath}/favorites">
                        <i class="fas fa-heart"></i> Favorites
                    </a>
                </nav>

                <div class="user-info">
                    <c:choose>
                        <c:when test="${not empty sessionScope.userId}">
                            <span>Welcome, <strong>${sessionScope.userName}</strong>!</span>
                            <a href="${pageContext.request.contextPath}/logout">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login">
                                <i class="fas fa-sign-in-alt"></i> Login
                            </a>
                            <a href="${pageContext.request.contextPath}/register">
                                <i class="fas fa-user-plus"></i> Register
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>

                <button class="mobile-menu-btn" id="mobileMenuBtn" aria-label="Toggle mobile menu">
                    <span></span>
                    <span></span>
                    <span></span>
                </button>
            </div>
        </header>

        <main class="container" style="padding-top: var(--space-2xl);">

            <c:if test="${not empty error}">
                <div class="error-message animate-slide-up">
                    <i class="fas fa-exclamation-triangle"></i>
                    <c:out value="${error}"/>
                </div>
            </c:if>

            <div class="form-container" style="max-width: 1300px; margin: 0 auto;">
                <form action="${pageContext.request.contextPath}/addRemedy" method="post" class="form animate-fade-in">
                    <div class="form-intro" style="text-align: center; margin-bottom: var(--space-xl); padding-bottom: var(--space-xl); border-bottom: 1px solid var(--border-light);">
                        <h3 style="font-size: 1.5rem; font-weight: 700; color: var(--primary-dark); margin-bottom: var(--space-sm);">
                            Share Your Remedy
                        </h3>
                    </div>

                    <label for="title">
                        Remedy Title
                        
                    </label>
                    <input id="title" name="title" type="text" required 
                           placeholder="Enter remedy title..." 
                           maxlength="100"/>

                    <label for="description">
                        Detailed Description
                    </label>
                    <textarea id="description" name="description" rows="4" 
                              placeholder=""></textarea>

                    <!--<div class="form-disclaimer" style="background: rgba(255, 248, 220, 0.8); border: 1px solid #fbbf24; border-radius: var(--radius-lg); padding: var(--space-lg); margin: var(--space-lg) 0; border-left: 4px solid var(--warning);">
                        <h4 style="color: #92400e; margin-bottom: var(--space-sm); display: flex; align-items: center; gap: var(--space-sm);">
                            <i class="fas fa-info-circle"></i>
                            Important Reminder
                        </h4>
                        <p style="color: #92400e; font-size: 0.95rem; line-height: 1.6;">
                            Home remedies are for informational purposes only and should not replace professional medical advice. Always consult healthcare providers for serious conditions.
                        </p>
                    </div> -->

                    <div class="form-actions">
                        <button class="btn" type="submit">
                            <i class="fas fa-paper-plane"></i> Share Remedy
                        </button>
                        <a class="btn outline" href="${pageContext.request.contextPath}/">
                            <i class="fas fa-times"></i> Cancel
                        </a>
                    </div>
                </form>
            </div>
        </main>

        <footer class="site-footer">
            <div class="container">
                <p>&copy; 2025 HealAt.Home - Natural Wellness Community | Noor Fatima <i class="fas fa-heart" style="color: #ffffff;"></i></p>
            </div>
        </footer>

        <script>
            // Mobile menu toggle
            const mobileMenuBtn = document.getElementById('mobileMenuBtn');
            const mainNav = document.getElementById('mainNav');

            mobileMenuBtn.addEventListener('click', function () {
                mainNav.classList.toggle('active');
                mobileMenuBtn.classList.toggle('active');
            });

            // Header scroll effect
            const header = document.getElementById('header');
            window.addEventListener('scroll', function () {
                if (window.scrollY > 100) {
                    header.classList.add('scrolled');
                } else {
                    header.classList.remove('scrolled');
                }
            });

            // Close mobile menu when clicking outside
            document.addEventListener('click', function (event) {
                if (!mobileMenuBtn.contains(event.target) && !mainNav.contains(event.target)) {
                    mainNav.classList.remove('active');
                    mobileMenuBtn.classList.remove('active');
                }
            });

            // Form enhancement
            const categorySelect = document.getElementById('category');
            const titleInput = document.getElementById('title');
            const descriptionTextarea = document.getElementById('description');

            // Auto-focus on title input
            titleInput.focus();

            // Character counter for title
            titleInput.addEventListener('input', function () {
                const remaining = 100 - this.value.length;
                let counter = document.getElementById('titleCounter');
                if (!counter) {
                    counter = document.createElement('small');
                    counter.id = 'titleCounter';
                    counter.style.cssText = 'color: var(--text-muted); float: right; margin-top: var(--space-xs);';
                    this.parentNode.appendChild(counter);
                }
                counter.textContent = `${remaining} characters remaining`;
                counter.style.color = remaining < 20 ? 'var(--warning)' : 'var(--text-muted)';
            });

            // Enhanced focus states for select
            categorySelect.addEventListener('focus', function () {
                this.style.borderColor = 'var(--primary)';
                this.style.boxShadow = '0 0 0 4px rgba(63, 155, 89, 0.12)';
                this.style.transform = 'translateY(-2px)';
                this.style.background = 'var(--white)';
            });

            categorySelect.addEventListener('blur', function () {
                this.style.borderColor = 'var(--border-light)';
                this.style.boxShadow = 'none';
                this.style.transform = 'translateY(0)';
                this.style.background = 'rgba(255, 255, 255, 0.9)';
            });

            // Auto-resize textarea
            descriptionTextarea.addEventListener('input', function () {
                this.style.height = 'auto';
                this.style.height = Math.min(this.scrollHeight, 400) + 'px';
            });
        </script>
    </body>
</html>