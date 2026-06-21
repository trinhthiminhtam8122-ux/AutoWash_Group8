<%@page import="java.sql.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="dto.Customer"%>
<%@page import="dto.Account"%>
<%@ page import="java.util.List" %>
<%@ page import="dto.Booking" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalTime" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html;charset=UTF-8");
    List<Booking> bookingList = (List<Booking>) request.getAttribute("bookings");

    Account account = (Account) session.getAttribute("LOGIN_USER");
    Customer customer = (Customer) session.getAttribute("CUSTOMER_INFO");
    String userName;
    if (customer != null) {
        userName = customer.getFullName();
    } else if (account != null) {
        userName = account.getUsername();
    } else {
        userName = "GUEST";
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>AutoWash - Booking History</title>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css" />
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
            .status-badge.pending   { background: #fef3c7; color: #d97706; }
            .status-badge.confirmed { background: #dbeafe; color: #2563eb; }
            .status-badge.washing   { background: #e0e7ff; color: #4f46e5; }
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

            /* ── Cancel button ── */
            .btn-cancel {
                display: inline-flex;
                align-items: center;
                gap: 0.4rem;
                padding: 0.45rem 1rem;
                border-radius: 10px;
                border: 1.5px solid #dc2626;
                background: transparent;
                color: #dc2626;
                font-size: 0.85rem;
                font-weight: 600;
                cursor: pointer;
                transition: background 0.15s, color 0.15s;
                font-family: inherit;
                white-space: nowrap;
            }
            .btn-cancel:hover { background: #dc2626; color: white; }

            .cancel-soon-note {
                font-size: 0.78rem;
                color: var(--text-muted);
                line-height: 1.4;
                max-width: 110px;
            }
            .cancel-soon-note i { color: #d97706; }

            /* ── Modal ── */
            .cancel-modal-overlay {
                display: none;
                position: fixed;
                inset: 0;
                background: rgba(0, 0, 0, 0.45);
                z-index: 9999;
                align-items: center;
                justify-content: center;
            }
            .cancel-modal-overlay.active { display: flex; }

            .cancel-modal {
                background: white;
                border-radius: 20px;
                padding: 2rem;
                width: 100%;
                max-width: 420px;
                margin: 1rem;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
                animation: modalIn 0.2s ease;
            }
            @keyframes modalIn {
                from { transform: translateY(-16px); opacity: 0; }
                to   { transform: translateY(0);     opacity: 1; }
            }
            .cancel-modal .modal-icon {
                width: 52px;
                height: 52px;
                border-radius: 50%;
                background: #fee2e2;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 1rem;
            }
            .cancel-modal .modal-icon i { font-size: 1.4rem; color: #dc2626; }
            .cancel-modal h3 {
                font-size: 1.15rem;
                font-weight: 700;
                color: var(--text-dark);
                margin-bottom: 0.5rem;
            }
            .cancel-modal p {
                color: var(--text-muted);
                font-size: 0.9rem;
                line-height: 1.6;
                margin-bottom: 0.35rem;
            }
            .cancel-modal .modal-notice {
                display: flex;
                align-items: flex-start;
                gap: 0.5rem;
                background: #fef3c7;
                border-radius: 10px;
                padding: 0.75rem 1rem;
                margin: 1rem 0 1.5rem;
                font-size: 0.85rem;
                color: #92400e;
            }
            .cancel-modal .modal-notice i { margin-top: 2px; flex-shrink: 0; }
            .modal-actions {
                display: flex;
                gap: 0.75rem;
                justify-content: flex-end;
            }
            .btn-keep {
                padding: 0.6rem 1.25rem;
                border-radius: 10px;
                border: 1.5px solid var(--border);
                background: white;
                color: var(--text-dark);
                font-weight: 600;
                font-size: 0.9rem;
                cursor: pointer;
                font-family: inherit;
                transition: background 0.15s;
            }
            .btn-keep:hover { background: #f1f5f9; }
            .btn-confirm-cancel {
                padding: 0.6rem 1.25rem;
                border-radius: 10px;
                border: none;
                background: #dc2626;
                color: white;
                font-weight: 600;
                font-size: 0.9rem;
                cursor: pointer;
                font-family: inherit;
                transition: background 0.15s;
            }
            .btn-confirm-cancel:hover { background: #b91c1c; }

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
                <div style="display: flex; align-items: center; gap: 0.5rem;">
                    <% if (customer != null && customer.getAvatarUrl() != null && !customer.getAvatarUrl().isEmpty()) {%>
                    <img src="<%= request.getContextPath() + (customer.getAvatarUrl().startsWith("/") ? "" : "/") + customer.getAvatarUrl()%>" alt="Avatar" style="width: 32px; height: 32px; border-radius: 50%; object-fit: cover;">
                    <% } else { %>
                    <i class="fa-regular fa-user"></i>
                    <% }%>
                    <span><%= userName%></span>
                </div>
                <% if (account != null) { %>
                <a href="LogoutController" class="logout-btn"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
                <% } else { %>
                <a href="javascript:void(0)" onclick="navTo('login')" class="logout-btn" style="background: var(--brand); color: white;"><i class="fa-solid fa-right-to-bracket"></i> Login</a>
                <% }%>
            </div>
        </nav>

            <main class="history-container">
                <div class="history-header">
                    <h1>Booking History</h1>
                    <p>Track all your past and upcoming car wash appointments.</p>
                </div>

                <%-- SUCCESS từ session (sau redirect của CancelBookingController) --%>
                <%
                    String successMsg = (String) session.getAttribute("SUCCESS_MSG");
                    if (successMsg != null) {
                        session.removeAttribute("SUCCESS_MSG");
                %>
                <div class="booking-alert success-alert" style="margin-bottom: 1rem;">
                    <i class="fa-solid fa-circle-check"></i>
                    <span><%= successMsg%></span>
                </div>
                <% } %>

                <%-- ERROR: đọc từ request trước, fallback sang session --%>
                <%
                    String errorMsg = (String) request.getAttribute("ERROR_MSG");
                    if (errorMsg == null) {
                        errorMsg = (String) session.getAttribute("ERROR_MSG");
                        if (errorMsg != null) {
                            session.removeAttribute("ERROR_MSG");
                        }
                    }
                    if (errorMsg != null) {
                %>
                <div class="booking-alert error-alert" style="margin-bottom: 1rem;">
                    <i class="fa-solid fa-circle-xmark"></i>
                    <span><%= errorMsg%></span>
                </div>
                <% } %>

                <div class="booking-list">
                    <% if (bookingList == null || bookingList.isEmpty()) { %>
                    <div class="empty-history">
                        <i class="fa-solid fa-clock-rotate-left"></i>
                        <h3>No bookings found</h3>
                        <p>You haven't made any bookings yet.</p>
                        <a href="javascript:void(0)" onclick="navTo('booking')" class="btn btn-primary">Book a Wash</a>
                    </div>
                    <%
                    } else {
                        SimpleDateFormat formatt = new SimpleDateFormat("dd/MM/yyyy");
                        for (Booking b : bookingList) {
                            String statusClass = (b.getStatus() != null) ? b.getStatus().toLowerCase() : "pending";

                            // Tính hiển thị giờ và khả năng cancel
                            String dateDisplay = "N/A";
                            String scheduledDisplay = "N/A";
                            boolean canCancel = false;

                            if (b.getScheduledDate() != null) {
                                dateDisplay = formatt.format(b.getScheduledDate());
                                if (b.getScheduledTime() != null) {
                                    scheduledDisplay = dateDisplay + " " + b.getScheduledTime().toString().substring(0, 5);
                                } else {
                                    scheduledDisplay = dateDisplay;
                                }
                            }

                            if ("Pending".equals(b.getStatus()) && b.getScheduledDate() != null && b.getScheduledTime() != null) {
                                LocalDateTime deadline = LocalDateTime.of(
                                    b.getScheduledDate().toLocalDate(),
                                    b.getScheduledTime().toLocalTime()
                                ).minusHours(2);
                                canCancel = LocalDateTime.now().isBefore(deadline);
                            }
                    %>
                    <div class="history-card">
                        <div class="info-group">
                            <span class="label">Date & Time</span>
                            <span class="value"><%= dateDisplay%></span>
                        </div>
                        <div class="info-group">
                            <span class="label">Vehicle</span>
                            <span class="value"><%= b.getVehiclePlateSnapshot()%></span>
                        </div>
                        <div class="info-group">
                            <span class="label">Service</span>
                            <span class="value"><%= b.getServiceType()%></span>
                        </div>
                        <div class="info-group">
                            <span class="label">Price</span>
                            <span class="value"><%= String.format("%,d", b.getPrice().longValue()).replace(',', '.')%>đ</span>
                        </div>
                        <div class="info-group">
                            <span class="label">Status</span>
                            <span class="status-badge <%= statusClass%>"><%= b.getStatus()%></span>
                        </div>

                        <%-- Cột Action: luôn render để giữ layout --%>
                        <div class="info-group action-group" style="min-width: 120px; align-items: flex-end; justify-content: center; display: flex;">
                            <% if ("Pending".equals(b.getStatus())) { %>
                                <% if (canCancel) { %>
                                <button class="btn-cancel"
                                        onclick="openCancelModal(<%= b.getBookingID()%>, '<%= scheduledDisplay%>')">
                                    <i class="fa-solid fa-xmark"></i> Cancel
                                </button>
                                <% } else { %>
                                <span class="cancel-soon-note" style="text-align: right;">
                                    <i class="fa-solid fa-clock"></i>
                                    Cannot cancel within 2h of appointment
                                </span>
                                <% } %>
                            <% } %>
                        </div>
                    </div>
                    <%
                        }
                    } %>
                </div>
            </main>
        </div>

        <%-- ===== Modal xác nhận Cancel ===== --%>
        <div class="cancel-modal-overlay" id="cancelModalOverlay" onclick="closeCancelModalOnOverlay(event)">
            <div class="cancel-modal">
                <div class="modal-icon">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                </div>
                <h3>Cancel Booking?</h3>
                <p>You're about to cancel <strong>Booking #<span id="modalBookingId"></span></strong>.</p>
                <p>Scheduled: <strong><span id="modalScheduled"></span></strong></p>
                <div class="modal-notice">
                    <i class="fa-solid fa-circle-info"></i>
                    <span>This action cannot be undone. Your vehicle and time slot will be released for new bookings.</span>
                </div>
                <div class="modal-actions">
                    <button class="btn-keep" onclick="closeCancelModal()">Keep Booking</button>
                    <form method="post" action="${pageContext.request.contextPath}/CancelBookingController" style="margin: 0;">
                        <input type="hidden" name="bookingID" id="cancelBookingIdInput">
                        <button type="submit" class="btn-confirm-cancel">
                            <i class="fa-solid fa-xmark"></i> Yes, Cancel
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <form id="postNavForm" action="${pageContext.request.contextPath}/main" method="POST" style="display:none;">
            <input type="hidden" name="action" id="postNavAction">
        </form>

        <script>
            function navTo(action) {
                document.getElementById('postNavAction').value = action;
                document.getElementById('postNavForm').submit();
            }

            function openCancelModal(bookingId, scheduled) {
                document.getElementById('modalBookingId').textContent = bookingId;
                document.getElementById('modalScheduled').textContent = scheduled;
                document.getElementById('cancelBookingIdInput').value = bookingId;
                document.getElementById('cancelModalOverlay').classList.add('active');
                document.body.style.overflow = 'hidden';
            }

            function closeCancelModal() {
                document.getElementById('cancelModalOverlay').classList.remove('active');
                document.body.style.overflow = '';
            }

            function closeCancelModalOnOverlay(event) {
                if (event.target === document.getElementById('cancelModalOverlay')) {
                    closeCancelModal();
                }
            }

            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') closeCancelModal();
            });
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    </body>
</html>