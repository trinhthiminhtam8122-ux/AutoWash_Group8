<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:url var="adminUrl" value="/AdminController" />
<c:url var="logoutUrl" value="/LogoutController" />
<c:url var="adminCss" value="/assets/css/admin-bookings.css" />
<c:url var="adminJs" value="/assets/js/admin-bookings.js" />
<c:set var="adminName" value="${sessionScope.LOGIN_USER.username}" />
<c:if test="${not empty sessionScope.STAFF_INFO.fullName}">
    <c:set var="adminName" value="${sessionScope.STAFF_INFO.fullName}" />
</c:if>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Car Wash Admin</title>
    <link rel="stylesheet" href="${adminCss}">
</head>
<body>
    <aside class="admin-sidebar">
        <div class="brand">
            <div class="brand-mark">
                <span class="brand-car">CAR</span>
            </div>
            <div class="brand-title">CAR WASH</div>
            <div class="brand-subtitle">MANAGEMENT SYSTEM</div>
        </div>

        <nav class="sidebar-nav">
            <a class="nav-item ${activePage == 'today' ? 'active' : ''}" href="${adminUrl}?action=today">
                <span class="nav-icon">&#9635;</span>
                <span>Today Bookings</span>
            </a>
            <a class="nav-item ${activePage == 'all' ? 'active' : ''}" href="${adminUrl}?action=all">
                <span class="nav-icon">&#9636;</span>
                <span>All Bookings</span>
            </a>
            <span class="nav-item disabled">
                <span class="nav-icon">&#9719;</span>
                <span>Customers</span>
                <span class="soon">Coming soon</span>
            </span>
            <span class="nav-item disabled">
                <span class="nav-icon">&#9719;</span>
                <span>Services</span>
                <span class="soon">Coming soon</span>
            </span>
        </nav>

        <a class="logout-link" href="${logoutUrl}">
            <span class="nav-icon">&#8618;</span>
            <span>Logout</span>
        </a>
    </aside>

    <div class="admin-shell">
        <header class="topbar">
            <div></div>
            <div class="admin-profile">
                <span class="avatar"></span>
                <span><c:out value="${adminName}" default="Admin" /></span>
                <span class="chevron">&#8964;</span>
            </div>
        </header>

        <main class="content">
            <section class="page-heading">
                <h1><c:out value="${pageTitle}" /></h1>
                <div class="search-box">
                    <span>&#8981;</span>
                    <input type="text" placeholder="Search by customer name, phone, plate..." disabled>
                </div>
            </section>

            <c:if test="${not empty sessionScope.SUCCESS_MSG}">
                <div class="alert success"><c:out value="${sessionScope.SUCCESS_MSG}" /></div>
                <c:remove var="SUCCESS_MSG" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.ERROR_MSG}">
                <div class="alert error"><c:out value="${sessionScope.ERROR_MSG}" /></div>
                <c:remove var="ERROR_MSG" scope="session" />
            </c:if>
            <c:if test="${not empty ERROR_MSG}">
                <div class="alert error"><c:out value="${ERROR_MSG}" /></div>
            </c:if>

            <c:if test="${activePage == 'today'}">
                <section class="summary-grid">
                    <div class="summary-card blue">
                        <span class="summary-icon">&#9635;</span>
                        <div>
                            <p>Today Bookings</p>
                            <strong><c:out value="${counts.todayBookings}" default="0" /></strong>
                        </div>
                    </div>
                    <div class="summary-card amber">
                        <span class="summary-icon">&#9675;</span>
                        <div>
                            <p>Pending</p>
                            <strong><c:out value="${counts.pending}" default="0" /></strong>
                        </div>
                    </div>
                    <div class="summary-card violet">
                        <span class="summary-icon">~</span>
                        <div>
                            <p>Washing</p>
                            <strong><c:out value="${counts.washing}" default="0" /></strong>
                        </div>
                    </div>

                    <div class="summary-card green">
                        <span class="summary-icon">&#10003;</span>
                        <div>
                            <p>Completed</p>
                            <strong><c:out value="${counts.completed}" default="0" /></strong>
                        </div>
                    </div>
                </section>

                <section class="station-card">
                    <div class="station-left">
                        <div class="station-icon">CAR</div>
                        <div>
                            <h2>Station 1</h2>
                            <c:choose>
                                <c:when test="${not empty stationBooking}">
                                    <span class="status-badge ${stationBooking.statusClass} station-status"
                                          data-seconds="${stationBooking.remainingSeconds}">
                                        <c:out value="${stationBooking.statusText}" />
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge empty">Available</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="station-divider"></div>
                    <div class="station-info">
                        <span>License Plate</span>
                        <strong><c:out value="${stationBooking.licensePlate}" default="-" /></strong>
                    </div>
                    <div class="station-divider"></div>
                    <div class="station-info">
                        <span>Remaining Time</span>
                        <strong class="station-timer" data-seconds="${stationBooking.remainingSeconds}">
                            <c:out value="${stationBooking.timerText}" default="-" />
                        </strong>
                    </div>
                </section>
            </c:if>

            <section class="booking-table-wrap">
                <table class="booking-table">
                    <thead>
                        <tr>
                            <th>Booking ID</th>
                            <th>Customer</th>
                            <th>Phone</th>
                            <th>License Plate</th>
                            <th>Vehicle</th>
                            <th>Service</th>
                            <c:if test="${activePage == 'all'}">
                                <th>Scheduled Date</th>
                            </c:if>
                            <th>Scheduled Time</th>
                            <th>Station</th>
                            <th>Status</th>
                            <th>Timer</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty bookings}">
                                <tr>
                                    <td class="empty-row" colspan="${activePage == 'all' ? 12 : 11}">
                                        No bookings found.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="booking" items="${bookings}">
                                    <tr data-booking-id="${booking.bookingID}">
                                        <td><c:out value="${booking.bookingCode}" /></td>
                                        <td><c:out value="${booking.customerName}" /></td>
                                        <td><c:out value="${booking.phone}" /></td>
                                        <td><c:out value="${booking.licensePlate}" /></td>
                                        <td><c:out value="${booking.vehicleModel}" default="-" /></td>
                                        <td><c:out value="${booking.serviceName}" /></td>
                                        <c:if test="${activePage == 'all'}">
                                            <td><fmt:formatDate value="${booking.scheduledDate}" pattern="dd/MM/yyyy" /></td>
                                        </c:if>
                                        <td>${booking.scheduledTimeStr}</td>
                                        <td><c:out value="${booking.stationText}" /></td>
                                        <td>
                                            <span class="status-badge ${booking.statusClass} row-status"
                                                  data-seconds="${booking.remainingSeconds}">
                                                <c:out value="${booking.statusText}" />
                                            </span>
                                        </td>
                                        <td>
                                            <span class="timer-value" data-seconds="${booking.remainingSeconds}">
                                                <c:out value="${booking.timerText}" />
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${activePage == 'today' && booking.pending}">
                                                    <c:choose>
                                                        <c:when test="${stationBusy}">
                                                            <button class="action-btn checkin" type="button" disabled>Check-in</button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <form action="${adminUrl}" method="post">
                                                                <input type="hidden" name="action" value="checkIn">
                                                                <input type="hidden" name="bookingID" value="${booking.bookingID}">
                                                                <button class="action-btn checkin" type="submit">Check-in</button>
                                                            </form>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:when test="${activePage == 'today' && booking.washing}">
                                                    <div class="washing-action" data-seconds="${booking.remainingSeconds}">
                                                        <span class="waiting-label ${booking.needCheckout ? 'is-hidden' : ''}">Waiting</span>
                                                        <form action="${adminUrl}" method="post"
                                                              class="checkout-form ${booking.needCheckout ? '' : 'is-hidden'}">
                                                            <input type="hidden" name="action" value="checkOut">
                                                            <input type="hidden" name="bookingID" value="${booking.bookingID}">
                                                            <button class="action-btn checkout" type="submit">Check-out</button>
                                                        </form>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="action-btn view" type="button">View</button>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </section>
        </main>
    </div>

    <script src="${adminJs}"></script>
</body>
</html>