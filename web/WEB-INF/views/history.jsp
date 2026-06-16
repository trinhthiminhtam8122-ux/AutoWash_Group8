<%@page import="dto.Customer"%>
<%@page import="dto.Account"%>
<%@ page import="java.util.List" %>
<%@ page import="dto.Booking" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html;charset=UTF-8");
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    String customerName = request.getAttribute("customerName") != null ? (String) request.getAttribute("customerName") : "Customer";

    Account acc = (Account) session.getAttribute("LOGIN_USER");
    Customer customer = (Customer) session.getAttribute("CUSTOMER_INFO");
    String userName = (customer != null) ? customer.getFullName() : (acc != null ? acc.getUsername() : "Guest");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>AutoWash - Booking History</title>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/booking.css" />
        <style>
            .history-container {
                max-width: 1000px;
                margin: 2rem auto;
                padding: 0 2rem;
            }
            .history-header {
                margin-bottom: 2rem;
            }
            .history-header h1 {
                font-size: 2rem;
                font-weight: 800;
                color: var(--text-dark);
            }
            .history-header p {
                color: var(--text-muted);
                margin-top: 0.5rem;
            }
            .booking-list {
                display: flex;
                flex-direction: column;
                gap: 1.5rem;
            }
            .history-card {
                background: white;
                border-radius: 16px;
                padding: 1.5rem;
                border: 1px solid var(--border);
                display: flex;
                flex-wrap: wrap;
                justify-content: space-between;
                align-items: center;
                gap: 1.5rem;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            }
            .history-card .info-group {
                display: flex;
                flex-direction: column;
                gap: 0.25rem;
                min-width: 120px;
            }
            .info-group span.label {
                font-size: 0.85rem;
                color: var(--text-muted);
                font-weight: 500;
            }
            .info-group span.value {
                font-weight: 600;
                color: var(--text-dark);
                font-size: 1rem;
            }
            .status-badge {
                padding: 0.4rem 1rem;
                border-radius: 20px;
                font-size: 0.85rem;
                font-weight: 600;
                text-transform: capitalize;
                text-align: center;
            }
            .status-badge.pending { background: #fef3c7; color: #d97706; }
            .status-badge.confirmed { background: #dbeafe; color: #2563eb; }
            .status-badge.washing { background: #e0e7ff; color: #4f46e5; }
            .status-badge.completed { background: #dcfce7; color: #16a34a; }
            .status-badge.cancelled { background: #fee2e2; color: #dc2626; }
            
            .empty-history {
                text-align: center;
                padding: 4rem 2rem;
                background: white;
                border-radius: 16px;
                border: 1px solid var(--border);
            }
            .empty-history i {
                font-size: 3rem;
                color: #cbd5e1;
                margin-bottom: 1rem;
            }
            .empty-history h3 {
                font-size: 1.25rem;
                color: var(--text-dark);
                margin-bottom: 0.5rem;
            }
            .empty-history p {
                color: var(--text-muted);
                margin-bottom: 1.5rem;
            }
            @media (max-width: 600px) {
                .history-card {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 1rem;
                }
            }
        </style>
    </head>
    <body>
        <div class="page-shell">
            <nav>
                <a href="javascript:void(0)" onclick="navTo('home')" class="brand"><i class="fa-solid fa-car-burst"></i> AutoWash</a>
                <div class="nav-links">
                    <a href="javascript:void(0)" onclick="navTo('dashboard')">Home</a>
                    <a href="javascript:void(0)" onclick="navTo('booking')">Booking</a>
                    <a href="javascript:void(0)" onclick="navTo('history')">History</a>
                    <a href="javascript:void(0)" onclick="navTo('profile')">Profile</a>
                </div>
                <div class="nav-right">
                    <div class="user-info">
                        <% if (customer != null && customer.getAvatarUrl() != null && !customer.getAvatarUrl().isEmpty()) {%>
                        <img src="<%= request.getContextPath() + (customer.getAvatarUrl().startsWith("/") ? "" : "/") + customer.getAvatarUrl()%>" alt="Avatar">
                        <% } else { %>
                        <i class="fa-regular fa-user"></i>
                        <% }%>
                        <span><%= userName%></span>
                    </div>
                    <% if (acc != null) { %>
                    <a href="LogoutController" class="logout-btn"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
                    <% } else { %>
                    <a href="javascript:void(0)" onclick="navTo('login')" class="logout-btn"><i class="fa-solid fa-right-to-bracket"></i> Login</a>
                    <% }%>
                </div>
            </nav>

            <main class="history-container">
                <div class="history-header">
                    <h1>Booking History</h1>
                    <p>Track all your past and upcoming car wash appointments.</p>
                </div>
                
                <% String successMsg = (String) session.getAttribute("SUCCESS_MSG");
                   if (successMsg != null) { 
                       session.removeAttribute("SUCCESS_MSG");
                %>
                <div class="booking-alert success-alert" style="margin-bottom: 1rem;">
                    <i class="fa-solid fa-circle-check"></i>
                    <span><%= successMsg %></span>
                </div>
                <% } %>
                
                <% String errorMsg = (String) request.getAttribute("ERROR_MSG");
                   if (errorMsg != null) { %>
                <div class="booking-alert error-alert" style="margin-bottom: 1rem;">
                    <i class="fa-solid fa-circle-xmark"></i>
                    <span><%= errorMsg %></span>
                </div>
                <% } %>

                <div class="booking-list">
                    <% if (bookings == null || bookings.isEmpty()) { %>
                        <div class="empty-history">
                            <i class="fa-solid fa-clock-rotate-left"></i>
                            <h3>No bookings found</h3>
                            <p>You haven't made any bookings yet.</p>
                            <a href="javascript:void(0)" onclick="navTo('booking')" class="btn btn-primary">Book a Wash</a>
                        </div>
                    <% } else { 
                        for (Booking b : bookings) { 
                            
                            String statusClass = b.getStatus() != null ? b.getStatus().toLowerCase() : "pending";
                    %>
                        <div class="history-card">
                            <div class="info-group">
                                <span class="label">Date & Time</span>
                                <span class="value"><%= (b.getScheduledDate() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(b.getScheduledDate()) : "N/A") %> - <%= (b.getScheduledTime() != null ? String.format("%tR", b.getScheduledTime()) : "N/A") %></span>
                            </div>
                            <div class="info-group">
                                <span class="label">Vehicle</span>  
                                <span class="value"><%= b.getVehiclePlateSnapshot() %></span>
                            </div>
                            <div class="info-group">
                                <span class="label">Service</span>
                                <span class="value"><%= b.getServiceType() %></span>
                            </div>
                            <div class="info-group">
                                <span class="label">Price</span>
                                <span class="value"><%= String.format("%,d", b.getPrice().longValue()).replace(',', '.') %>đ</span>
                            </div>
                            <div class="info-group">
                                <span class="label">Status</span>
                                <span class="status-badge <%= statusClass %>"><%= b.getStatus() %></span>
                            </div>
                        </div>
                    <%  }
                    } %>
                </div>
            </main>
        </div>

        <form id="postNavForm" action="${pageContext.request.contextPath}/main" method="POST" style="display:none;">
            <input type="hidden" name="action" id="postNavAction">
        </form>
        <script>
            function navTo(action) {
                document.getElementById('postNavAction').value = action;
                document.getElementById('postNavForm').submit();
            }
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    </body>
</html>
