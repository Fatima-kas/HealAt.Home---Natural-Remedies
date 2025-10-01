<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.homeremedies.util.DBUtil, java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String query = request.getParameter("q");
    List<Map<String, Object>> results = new ArrayList<>();
    Integer loggedInUserId = (Integer) session.getAttribute("userId");
    Set<Integer> userFavorites = new HashSet<>();
    
    // Get user's favorites if logged in
    if (loggedInUserId != null) {
        try (Connection conn = DBUtil.getConnection()) {
            String favSql = "SELECT remedy_id FROM favorites WHERE user_id = ?";
            PreparedStatement ps = conn.prepareStatement(favSql);
            ps.setInt(1, loggedInUserId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                userFavorites.add(rs.getInt("remedy_id"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    if (query != null && !query.trim().isEmpty()) {
        String sql = "SELECT r.id, r.title, r.description, r.category, " +
                    "COALESCE(AVG(rr.rating), 0) as avg_rating, " +
                    "COUNT(rr.id) as rating_count " +
                    "FROM remedies r " +
                    "LEFT JOIN remedy_ratings rr ON r.id = rr.remedy_id " +
                    "WHERE (r.title LIKE ? OR r.description LIKE ? OR r.category LIKE ?) " +
                    "AND r.status = 'approved' " +
                    "GROUP BY r.id, r.title, r.description, r.category " +
                    "ORDER BY avg_rating DESC, rating_count DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String like = "%" + query.trim() + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> remedy = new HashMap<>();
                    remedy.put("id", rs.getInt("id"));
                    remedy.put("title", rs.getString("title"));
                    remedy.put("description", rs.getString("description"));
                    remedy.put("category", rs.getString("category"));
                    remedy.put("avg_rating", rs.getDouble("avg_rating"));
                    remedy.put("rating_count", rs.getInt("rating_count"));
                    results.add(remedy);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    pageContext.setAttribute("query", query);
    pageContext.setAttribute("results", results);
    pageContext.setAttribute("userFavorites", userFavorites);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search<c:if test="${not empty query}"> - ${query}</c:if> - HealAt.Home</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        .favorite-icon {
            position: absolute;
            top: var(--space-lg);
            right: var(--space-lg);
            font-size: 1.5rem;
            cursor: pointer;
            color: #d1d5db;
            transition: all 0.3s ease;
            z-index: 10;
        }
        .favorite-icon:hover {
            transform: scale(1.2);
            color: #f87171;
        }
        .favorite-icon.favorited {
            color: #ec4899;
            animation: heartBeat 0.3s ease;
        }
        @keyframes heartBeat {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.3); }
        }
    </style>
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
                <a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Home</a>
                <a href="${pageContext.request.contextPath}/search" class="active"><i class="fas fa-search"></i> Search</a>
                <a href="${pageContext.request.contextPath}/addRemedy"><i class="fas fa-plus-circle"></i> Add Remedy</a>
                <a href="${pageContext.request.contextPath}/favorites"><i class="fas fa-heart"></i> Favorites</a>
            </nav>

            <div class="user-info">
                <c:choose>
                    <c:when test="${not empty sessionScope.userId}">
                        <span>Welcome, <strong>${sessionScope.userName}</strong>!</span>
                        <a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login"><i class="fas fa-sign-in-alt"></i> Login</a>
                        <a href="${pageContext.request.contextPath}/register"><i class="fas fa-user-plus"></i> Register</a>
                    </c:otherwise>
                </c:choose>
            </div>

            <button class="mobile-menu-btn" id="mobileMenuBtn" aria-label="Toggle mobile menu">
                <span></span><span></span><span></span>
            </button>
        </div>
    </header>

    <main class="container" style="padding: var(--space-3xl) var(--space-lg);">
        <div class="animate-fade-in">
            <h2 style="text-align: center; margin-bottom: var(--space-2xl);">
                <i class="fas fa-search"></i> Search Remedies
            </h2>

            <form action="${pageContext.request.contextPath}/search" method="get" class="search-form">
                <input type="text" name="q" placeholder="Search for remedies, symptoms, or categories..." value="${query}" required autofocus/>
                <button type="submit" class="btn"><i class="fas fa-search"></i> Search</button>
            </form>

            <c:choose>
                <c:when test="${not empty query}">
                    <div style="text-align: center; margin: var(--space-2xl) 0;">
                        <h3 style="color: var(--text-secondary); font-weight: 500;">
                            Search results for "<strong style="color: var(--primary);">${query}</strong>"
                        </h3>
                        <p style="color: var(--text-muted); font-size: var(--font-size-sm);">
                            <c:choose>
                                <c:when test="${not empty results}">Found ${results.size()} ${results.size() == 1 ? 'remedy' : 'remedies'}</c:when>
                                <c:otherwise>No remedies found</c:otherwise>
                            </c:choose>
                        </p>
                    </div>

                    <c:choose>
                        <c:when test="${not empty results}">
                            <div class="results-grid">
                                <c:forEach var="remedy" items="${results}">
                                    <div class="remedy-card animate-slide-up" style="position: relative;">
                                        
                                        <!-- Favorite Heart Icon -->
                                        <c:set var="isFavorited" value="${userFavorites.contains(remedy.id)}" />
                                        <i class="${isFavorited ? 'fas' : 'far'} fa-heart favorite-icon ${isFavorited ? 'favorited' : ''}" 
                                           data-remedy-id="${remedy.id}"
                                           onclick="toggleFavorite(${remedy.id}, this)"
                                           title="${isFavorited ? 'Remove from favorites' : 'Add to favorites'}">
                                        </i>
                                        
                                        <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: var(--space-md); padding-right: var(--space-3xl);">
                                            <h3 style="margin: 0; flex: 1;">${remedy.title}</h3>
                                            <span class="category">${remedy.category}</span>
                                        </div>
                                        
                                        <!-- Rating Display -->
                                        <div style="display: flex; align-items: center; gap: var(--space-sm); margin-bottom: var(--space-md);">
                                            <div style="display: flex; gap: 2px;">
                                                <%
                                                    Map<String, Object> currentRemedy = (Map<String, Object>) pageContext.getAttribute("remedy");
                                                    double avgRating = ((Number) currentRemedy.get("avg_rating")).doubleValue();
                                                    int fullStars = (int) Math.floor(avgRating);
                                                    boolean hasHalfStar = (avgRating - fullStars) >= 0.5;
                                                    
                                                    for (int i = 1; i <= 5; i++) {
                                                        if (i <= fullStars) {
                                                %>
                                                            <i class="fas fa-star" style="color: #fbbf24; font-size: 0.875rem;"></i>
                                                <%
                                                        } else if (i == fullStars + 1 && hasHalfStar) {
                                                %>
                                                            <i class="fas fa-star-half-alt" style="color: #fbbf24; font-size: 0.875rem;"></i>
                                                <%
                                                        } else {
                                                %>
                                                            <i class="far fa-star" style="color: #d1d5db; font-size: 0.875rem;"></i>
                                                <%
                                                        }
                                                    }
                                                %>
                                            </div>
                                            <span style="font-size: var(--font-size-sm); color: var(--text-muted);">
                                                <fmt:formatNumber value="${remedy.avg_rating}" maxFractionDigits="1" minFractionDigits="1"/>
                                                (${remedy.rating_count})
                                            </span>
                                        </div>
                                        
                                        <p>
                                            <c:choose>
                                                <c:when test="${remedy.description.length() > 150}">
                                                    ${remedy.description.substring(0, 150)}...
                                                </c:when>
                                                <c:otherwise>
                                                    ${remedy.description}
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        
                                        <!-- Rating Widget (Inline) -->
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.userId}">
                                                <div style="background: #f9fafb; padding: var(--space-md); border-radius: var(--radius-md); margin-top: var(--space-lg);">
                                                    <div style="font-size: var(--font-size-sm); color: var(--text-secondary); margin-bottom: var(--space-xs);">
                                                        Rate this remedy:
                                                    </div>
                                                    <div class="rating-input" style="display: flex; gap: var(--space-xs);">
                                                        <i class="fas fa-star star" data-rating="1" data-remedy-id="${remedy.id}" style="font-size: 1.5rem; cursor: pointer; color: #d1d5db;"></i>
                                                        <i class="fas fa-star star" data-rating="2" data-remedy-id="${remedy.id}" style="font-size: 1.5rem; cursor: pointer; color: #d1d5db;"></i>
                                                        <i class="fas fa-star star" data-rating="3" data-remedy-id="${remedy.id}" style="font-size: 1.5rem; cursor: pointer; color: #d1d5db;"></i>
                                                        <i class="fas fa-star star" data-rating="4" data-remedy-id="${remedy.id}" style="font-size: 1.5rem; cursor: pointer; color: #d1d5db;"></i>
                                                        <i class="fas fa-star star" data-rating="5" data-remedy-id="${remedy.id}" style="font-size: 1.5rem; cursor: pointer; color: #d1d5db;"></i>
                                                    </div>
                                                    <div id="msg-${remedy.id}" style="display: none; margin-top: var(--space-xs); font-size: var(--font-size-xs);"></div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div style="background: #f0fdf4; padding: var(--space-md); border-radius: var(--radius-md); margin-top: var(--space-lg); text-align: center;">
                                                    <a href="${pageContext.request.contextPath}/login" class="btn small">
                                                        <i class="fas fa-sign-in-alt"></i> Login to Rate
                                                    </a>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state animate-fade-in">
                                <i class="fas fa-search"></i>
                                <h3>No results found</h3>
                                <p>Try searching with different keywords or browse all remedies.</p>
                                <a href="${pageContext.request.contextPath}/" class="btn" style="margin-top: var(--space-lg);">
                                    <i class="fas fa-home"></i> Back to Home
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; margin-top: var(--space-3xl);">
                        <i class="fas fa-lightbulb" style="font-size: 4rem; color: var(--accent); margin-bottom: var(--space-lg);"></i>
                        <h3 style="color: var(--text-secondary); font-weight: 500;">Search Tips</h3>
                        <div style="max-width: 600px; margin: var(--space-xl) auto;">
                            <div class="card" style="text-align: left;">
                                <ul style="list-style: none; padding: 0; margin: 0;">
                                    <li style="padding: var(--space-sm) 0; border-bottom: 1px solid var(--border-light);">
                                        <i class="fas fa-check" style="color: var(--success); margin-right: var(--space-sm);"></i>
                                        Search by symptom (e.g., "headache", "cold")
                                    </li>
                                    <li style="padding: var(--space-sm) 0; border-bottom: 1px solid var(--border-light);">
                                        <i class="fas fa-check" style="color: var(--success); margin-right: var(--space-sm);"></i>
                                        Search by ingredient (e.g., "honey", "ginger")
                                    </li>
                                    <li style="padding: var(--space-sm) 0; border-bottom: 1px solid var(--border-light);">
                                        <i class="fas fa-check" style="color: var(--success); margin-right: var(--space-sm);"></i>
                                        Search by category (e.g., "skin care", "digestion")
                                    </li>
                                    <li style="padding: var(--space-sm) 0;">
                                        <i class="fas fa-check" style="color: var(--success); margin-right: var(--space-sm);"></i>
                                        Browse highly-rated remedies
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <footer class="site-footer">
        <div class="container">
            <p>&copy; 2025 HealAt.Home - Natural Wellness Community | Noor Fatima <i class="fas fa-heart" style="color: #ffffff;"></i></p>
        </div>
    </footer>

    <script>
        const isLoggedIn = ${not empty sessionScope.userId};
        
        // Mobile menu
        const mobileMenuBtn = document.getElementById('mobileMenuBtn');
        const mainNav = document.getElementById('mainNav');
        if (mobileMenuBtn) {
            mobileMenuBtn.addEventListener('click', () => {
                mainNav.classList.toggle('active');
                mobileMenuBtn.classList.toggle('active');
            });
        }

        // Header scroll
        const header = document.getElementById('header');
        window.addEventListener('scroll', () => {
            header.classList.toggle('scrolled', window.scrollY > 100);
        });

        // Toggle Favorite
        function toggleFavorite(remedyId, icon) {
            if (!isLoggedIn) {
                alert('Please log in to add favorites');
                window.location.href = '${pageContext.request.contextPath}/login';
                return;
            }
            
            const isFavorited = icon.classList.contains('favorited');
            
            if (isFavorited) {
                // Remove from favorites
                fetch('${pageContext.request.contextPath}/favorites?remove=' + remedyId, {
                    method: 'GET'
                })
                .then(response => {
                    if (response.ok) {
                        icon.classList.remove('fas', 'favorited');
                        icon.classList.add('far');
                        icon.title = 'Add to favorites';
                    }
                })
                .catch(error => console.error('Error:', error));
            } else {
                // Add to favorites
                fetch('${pageContext.request.contextPath}/favorites?add=' + remedyId, {
                    method: 'GET'
                })
                .then(response => {
                    if (response.ok) {
                        icon.classList.remove('far');
                        icon.classList.add('fas', 'favorited');
                        icon.title = 'Remove from favorites';
                    }
                })
                .catch(error => console.error('Error:', error));
            }
        }

        // Rating functionality
        document.querySelectorAll('.star').forEach(star => {
            const remedyId = star.dataset.remedyId;
            
            // Hover
            star.addEventListener('mouseenter', function() {
                const rating = parseInt(this.dataset.rating);
                document.querySelectorAll(`.star[data-remedy-id="${remedyId}"]`).forEach((s, idx) => {
                    s.style.color = (idx < rating) ? '#fbbf24' : '#d1d5db';
                });
            });
            
            // Reset on leave
            star.parentElement.addEventListener('mouseleave', function() {
                document.querySelectorAll(`.star[data-remedy-id="${remedyId}"]`).forEach(s => {
                    s.style.color = '#d1d5db';
                });
            });
            
            // Click to rate
            star.addEventListener('click', function() {
                const rating = parseInt(this.dataset.rating);
                const msgDiv = document.getElementById('msg-' + remedyId);
                
                msgDiv.style.display = 'block';
                msgDiv.style.color = '#1e40af';
                msgDiv.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Submitting...';
                
                fetch('${pageContext.request.contextPath}/submitRating', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'remedyId=' + remedyId + '&rating=' + rating
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        msgDiv.style.color = '#065f46';
                        msgDiv.innerHTML = '<i class="fas fa-check-circle"></i> Thank you! Your rating has been saved.';
                        setTimeout(() => location.reload(), 1500);
                    } else {
                        msgDiv.style.color = '#991b1b';
                        msgDiv.innerHTML = '<i class="fas fa-exclamation-circle"></i> Failed to submit rating.';
                    }
                })
                .catch(error => {
                    msgDiv.style.color = '#991b1b';
                    msgDiv.innerHTML = '<i class="fas fa-exclamation-circle"></i> Error: ' + error.message;
                });
            });
        });
    </script>
</body>
</html>