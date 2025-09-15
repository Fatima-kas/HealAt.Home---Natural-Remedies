<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search — HealAt.Home</title>
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
                <a href="${pageContext.request.contextPath}/search" class="active">
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

    <main class="container" style="padding-top: var(--space-2xl);">
        <div class="search-header" style="text-align: center; margin-bottom: var(--space-2xl);">
            <c:choose>
                <c:when test="${not empty query}">
                    <h2 style="font-size: 2.5rem; font-weight: 800; color: var(--primary-dark); margin-bottom: var(--space-md);">
                        <i class="fas fa-search" style="color: var(--accent);"></i>
                        Search Results
                    </h2>
                    <p style="font-size: 1.2rem; color: var(--text-secondary);">
                        Found results for "<c:out value="${query}"/>"
                    </p>
                </c:when>
                <c:otherwise>
                    <h2 style="font-size: 2.5rem; font-weight: 800; color: var(--primary-dark); margin-bottom: var(--space-md);">
                        <i class="fas fa-search" style="color: var(--accent);"></i>
                        Search Remedies
                    </h2>
                    <p style="font-size: 1.2rem; color: var(--text-secondary);">
                        Find natural solutions for your health concerns
                    </p>
                </c:otherwise>
            </c:choose>
        </div>

        <form action="${pageContext.request.contextPath}/search" method="get" class="search-form" style="margin-bottom: var(--space-2xl);">
            <input name="q" value="<c:out value="${query}"/>" 
                   placeholder="Search remedies (Cold, Pimples, Hair, Headache...)" 
                   aria-label="Search for home remedies" autofocus/>
            <button class="btn" type="submit">
                <i class="fas fa-search"></i> Search
            </button>
        </form>

        <c:choose>
            <c:when test="${not empty query and empty results}">
                <div class="no-results" style="text-align: center; padding: var(--space-2xl); background: rgba(255, 255, 255, 0.8); border-radius: var(--radius-2xl); margin: var(--space-xl) 0;">
                    <i class="fas fa-search-minus" style="font-size: 4rem; color: var(--text-muted); margin-bottom: var(--space-lg);"></i>
                    <h3 style="font-size: 1.5rem; font-weight: 700; color: var(--text-primary); margin-bottom: var(--space-md);">
                        No results found
                    </h3>
                    <p style="color: var(--text-secondary); margin-bottom: var(--space-xl);">
                        We couldn't find any remedies matching "<c:out value="${query}"/>". Try a different keyword or help expand our database!
                    </p>
                    <div style="display: flex; flex-wrap: wrap; gap: var(--space-md); justify-content: center;">
                        <a href="${pageContext.request.contextPath}/addRemedy" class="btn">
                            <i class="fas fa-plus-circle"></i> Add a Remedy
                        </a>
                        <a href="${pageContext.request.contextPath}/search" class="btn outline">
                            <i class="fas fa-search"></i> Try New Search
                        </a>
                    </div>
                </div>
            </c:when>
            <c:when test="${not empty results}">
                <div class="results-summary" style="margin-bottom: var(--space-xl); text-align: center;">
                    <p style="color: var(--text-secondary); font-size: 1.1rem;">
                        <i class="fas fa-check-circle" style="color: var(--success);"></i>
                        Found <strong style="color: var(--primary);">${results.size()}</strong> 
                        ${results.size() == 1 ? 'remedy' : 'remedies'} for you
                    </p>
                </div>

                <div class="results-grid">
                    <c:forEach var="r" items="${results}" varStatus="status">
                        <div class="remedy-card animate-slide-up" style="animation-delay: ${status.index * 0.1}s;">
                            <div style="display: flex; justify-content: between; align-items: flex-start; margin-bottom: var(--space-md);">
                                <h3><c:out value="${r.title}"/></h3>
                                <c:if test="${not empty r.category}">
                                    <span class="category"><c:out value="${r.category}"/></span>
                                </c:if>
                            </div>
                            
                            <p><c:out value="${r.description}"/></p>
                            
                            <div class="actions" style="margin-top: var(--space-lg);">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.userId}">
                                        <a class="btn small" href="${pageContext.request.contextPath}/favorites?add=${r.id}">
                                            <i class="fas fa-heart"></i> Add to Favorites
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="btn small outline" href="${pageContext.request.contextPath}/login" 
                                           title="Login to add to favorites">
                                            <i class="fas fa-sign-in-alt"></i> Login to Save
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
        </c:choose>

        <div style="text-align: center; margin-top: var(--space-2xl); padding-top: var(--space-xl); border-top: 1px solid var(--border-light);">
            <a href="${pageContext.request.contextPath}/" class="btn outline">
                <i class="fas fa-home"></i> Back to Home
            </a>
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
        
        mobileMenuBtn.addEventListener('click', function() {
            mainNav.classList.toggle('active');
            mobileMenuBtn.classList.toggle('active');
        });

        // Header scroll effect
        const header = document.getElementById('header');
        window.addEventListener('scroll', function() {
            if (window.scrollY > 100) {
                header.classList.add('scrolled');
            } else {
                header.classList.remove('scrolled');
            }
        });

        // Close mobile menu when clicking outside
        document.addEventListener('click', function(event) {
            if (!mobileMenuBtn.contains(event.target) && !mainNav.contains(event.target)) {
                mainNav.classList.remove('active');
                mobileMenuBtn.classList.remove('active');
            }
        });
    </script>
</body>
</html>