<%@page import="dto.Customer"%>
<%@page import="dto.Account"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.Vehicle" %>
<%@ page import="dto.Service" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html;charset=UTF-8");
    List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
    List<Service> serviceList = (List<Service>) request.getAttribute("serviceList");
    String customerName = request.getAttribute("customerName") != null ? (String) request.getAttribute("customerName") : "Customer";
    String successMsg = (String) session.getAttribute("SUCCESS_MSG");
    String errorMsg = (String) request.getAttribute("ERROR_MSG");
    if (successMsg != null) {
        session.removeAttribute("SUCCESS_MSG");
    }

    Account acc = (Account) session.getAttribute("LOGIN_USER");
    Customer customer = (Customer) session.getAttribute("CUSTOMER_INFO");
    String userName = (customer != null) ? customer.getFullName() : (acc != null ? acc.getUsername() : "Guest");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>AutoWash - Quick Booking</title>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/booking.css" />
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

            <main class="booking-container">
                <% if (successMsg != null) {%>
                <div class="booking-alert success-alert">
                    <i class="fa-solid fa-circle-check"></i>
                    <span><%= successMsg%></span>
                </div>
                <% } else if (errorMsg != null) {%>
                <div class="booking-alert error-alert">
                    <i class="fa-solid fa-circle-xmark"></i>
                    <span><%= errorMsg%></span>
                </div>
                <% }%>

                <section class="booking-hero">
                    <div class="hero-copy">
                        <span class="eyebrow">Quick Booking</span>
                        <h1>Reserve your wash in seconds.</h1>
                        <p>Choose one of our premium packages and book your vehicle for a spotless result.</p>
                    </div>
                    <div class="hero-card">
                        <div>
                            <h3>Current Customer</h3>
                            <p><strong><%= customerName%></strong></p>
                        </div>
                        <div>
                            <p class="hero-note">Fast booking for active vehicles only.</p>
                        </div>
                    </div>
                </section>

                <section class="booking-grid">
                    <div class="booking-panel">
                        <div class="panel-head">
                            <div>
                                <h2>Pick your ride</h2>
                            </div>
                            <span class="step-tag">Required</span>
                        </div>

                        <% if (vehicles == null || vehicles.isEmpty()) { %>
                        <div class="empty-state">
                            <i class="fa-solid fa-car-side"></i>
                            <h3>No active vehicles found</h3>
                            <p>Please add a vehicle from your profile before booking a wash.</p>
                            <a href="javascript:void(0)" onclick="navTo('profile')" class="btn btn-secondary">Go to Profile</a>
                        </div>
                        <% } else { %>
                        <form id="bookingForm" class="booking-form" action="${pageContext.request.contextPath}/BookingController" method="POST" onsubmit="return handleBookingSubmit(event)">
                            <div class="field-group">
                                <label for="vehicleSelect">Select Vehicle</label>
                                <select id="vehicleSelect" name="vehicleID" required>
                                    <option value="">Choose vehicle</option>
                                    <% for (Vehicle vehicle : vehicles) {%>
                                    <option value="<%= vehicle.getVehicleID()%>"><%= vehicle.getVehicleModel() != null && !vehicle.getVehicleModel().isEmpty() ? vehicle.getVehicleModel() + " - " + vehicle.getLicensePlate() : vehicle.getLicensePlate()%></option>
                                    <% } %>
                                </select>
                            </div>

                            <div class="field-group service-section" id="services">
                                <div class="service-header">
                                    <div>
                                        <label>Choose a service</label>
                                        <p>Select a package that fits your car wash needs.</p>
                                    </div>
                                </div>

                                <div class="service-grid">
                                    <% if (serviceList != null && !serviceList.isEmpty()) {
                                        for (Service s : serviceList) {
                                            boolean isPremium = s.getServiceName() != null && (s.getServiceName().toLowerCase().contains("premium") || s.getServiceName().toLowerCase().contains("full") || s.getServiceName().toLowerCase().contains("detail"));
                                    %>
                                    <button type="button" class="service-card" 
                                            data-service-id="<%= s.getServiceID() %>" 
                                            data-service-name="<%= s.getServiceName() %>" 
                                            data-service-price="<%= s.getPrice() %>">
                                        <div class="service-badge <%= isPremium ? "premium" : "" %>"><%= s.getServiceName() %></div>
                                        <p><%= s.getDescription() != null ? s.getDescription() : "High-quality wash service for your vehicle." %></p>
                                        <div class="service-footer">
                                            <span><%= String.format("%,d", s.getPrice().longValue()).replace(',', '.') %>đ</span>
                                            <i class="fa-solid fa-check"></i>
                                        </div>
                                    </button>
                                    <%  }
                                    } else { %>
                                        <p style="grid-column: 1/-1; text-align: center; color: #666;">No services available at the moment.</p>
                                    <% } %>
                                </div>
                            </div>

                            <div class="date-time-grid">
                                <div class="field-group">
                                    <label for="scheduledDate">Booking Date</label>
                                    <input type="date" id="scheduledDate" name="scheduledDate" required />
                                </div>
                                <div class="field-group">
                                    <label for="scheduledTime">Time Slot</label>
                                    <select id="scheduledTime" name="scheduledTime" required>
                                        <option value="">Choose time slot</option>
                                        <option value="08:00">08:00</option>
                                        <option value="09:00">09:00</option>
                                        <option value="10:00">10:00</option>
                                        <option value="11:00">11:00</option>
                                        <option value="13:00">13:00</option>
                                        <option value="14:00">14:00</option>
                                        <option value="15:00">15:00</option>
                                        <option value="16:00">16:00</option>
                                    </select>
                                </div>
                            </div>

                            <input type="hidden" id="serviceID" name="serviceID" />
                            <input type="hidden" id="serviceType" name="serviceType" />
                            <input type="hidden" id="servicePrice" name="servicePrice" value="0" />

                            <div class="booking-summary-card">
                                <div class="summary-head">
                                    <h3>Booking Summary</h3>
                                    <p>Review your selected ride and service before confirming.</p>
                                </div>
                                <div class="summary-item">
                                    <span>Vehicle</span>
                                    <strong id="summaryVehicle">Not selected</strong>
                                </div>
                                <div class="summary-item">
                                    <span>Service</span>
                                    <strong id="summaryService">Not selected</strong>
                                </div>
                                <div class="summary-item">
                                    <span>Date</span>
                                    <strong id="summaryDate">Not selected</strong>
                                </div>
                                <div class="summary-item">
                                    <span>Time</span>
                                    <strong id="summaryTime">Not selected</strong>
                                </div>
                                <div class="summary-item total-row">
                                    <span>Total price</span>
                                    <strong id="summaryPrice">0đ</strong>
                                </div>
                            </div>

                            <button type="submit" id="bookingSubmit" class="btn btn-primary">Confirm Booking</button>
                        </form>
                        <% }%>
                    </div>

                    <aside class="info-panel">
                        <div class="info-card">
                            <h3>Why book now?</h3>
                            <p>Quick booking reserves your vehicle for the next available wash slot and preserves your vehicle snapshot at booking time.</p>
                        </div>
                        <div class="info-card highlight-card">
                            <h4>Full service preview</h4>
                            <ul>
                                <li><i class="fa-solid fa-check"></i> Vehicle snapshot stored with booking</li>
                                <li><i class="fa-solid fa-check"></i> Customer name recorded at creation</li>
                                <li><i class="fa-solid fa-check"></i> Status starts as Pending</li>
                            </ul>
                        </div>
                    </aside>
                </section>
            </main>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/booking.js"></script>
    </body>
</html>