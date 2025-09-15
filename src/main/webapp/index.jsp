<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Home — HealAt.Home</title>
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
                    <a href="${pageContext.request.contextPath}/" class="active">
                        <i class="fas fa-home"></i> Home
                    </a>
                    <a href="${pageContext.request.contextPath}/search">
                        <i class="fas fa-search"></i> Search
                    </a>
                    <a href="${pageContext.request.contextPath}/addRemedy">
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

        <main class="container hero">
            <div class="animate-fade-in">
                <h2>Natural care is often the gentlest care</h2>
                <p>Discover tested home remedies for everyday problems — colds, skin issues, and more.</p>

                <div class="hero-actions">
                    <a class="btn" href="${pageContext.request.contextPath}/search?q=cold">
                        <i class="fas fa-snowflake"></i> Remedies for Cold
                    </a>
                    <a class="btn outline" href="${pageContext.request.contextPath}/addRemedy">
                        <i class="fas fa-share-alt"></i> Share a Remedy
                    </a>
                </div>
            </div>

            <section class="slogans">
                <div class="card animate-slide-up" style="animation-delay: 0.1s">
                    <i class="fas fa-leaf" style="font-size: 2.5rem; color: var(--primary); margin-bottom: var(--space-md);"></i>
                    <h3>Safe & Natural</h3>
                    <p>Simple ingredients from your kitchen and garden.</p>
                </div>
                <div class="card animate-slide-up" style="animation-delay: 0.2s">
                    <i class="fas fa-users" style="font-size: 2.5rem; color: var(--accent); margin-bottom: var(--space-md);"></i>
                    <h3>Community Tested</h3>
                    <p>Real experiences from users — everyday tips shared by people.</p>
                </div>
                <div class="card animate-slide-up" style="animation-delay: 0.3s">
                    <i class="fas fa-hand-holding-heart" style="font-size: 2.5rem; color: var(--accent); margin-bottom: var(--space-md);"></i>
                    <h3>Easy to Try</h3>
                    <p>Most remedies are low-cost and easy to make.</p>
                </div>
            </section>
            <br><br><br><br>
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
            let lastScrollY = window.scrollY;

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
        </script>
    </body>
</html>