<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.Customer"%>
<%@page import="dto.Account"%>
<%@page import="dto.Service"%>
<%
    // Access without login allowed (Guest Mode)
    Account acc = (Account) session.getAttribute("LOGIN_USER");
    Customer customer = (Customer) session.getAttribute("CUSTOMER_INFO");
    List<Service> serviceList = (List<Service>) request.getAttribute("serviceList");

    String userName = "Guest";
    int currentPoints = 0;
    String tierName = "Gold member";

    if (customer != null) {
        userName = customer.getFullName();
        currentPoints = customer.getCurrentPoints();
        if (customer.getTierID() == 1) {
            tierName = "Bronze member";
        } else if (customer.getTierID() == 2) {
            tierName = "Silver member";
        } else if (customer.getTierID() == 3) {
            tierName = "Gold member";
        } else if (customer.getTierID() == 4) {
            tierName = "Platinum member";
        }
    } else if (acc != null) {
        userName = acc.getUsername();
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>AutoWash - Dashboard</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/messenger-chat.css">
    </head>
    <body>

        <nav>
            <a href="javascript:void(0)" onclick="navTo('home')" class="brand"><i class="fa-solid fa-car-burst"></i> AutoWash</a>
            <div class="nav-links">
                <a href="javascript:void(0)" onclick="navTo('dashboard')">Home</a>
                <a href="javascript:void(0)" onclick="navTo('booking')">Booking</a>
                <a href="#">Services</a>
                <a href="javascript:void(0)" onclick="navTo('profile')">Profile</a>
                <% if (acc != null && ("Admin".equals(acc.getRole()) || "Staff".equals(acc.getRole()))) { %>
                <a href="javascript:void(0)" onclick="navTo('admin')" style="color:var(--primary); font-weight:700;">Admin Panel</a>
                <% } %>
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
                <% if (acc != null) { %>
                <a href="LogoutController" class="logout-btn"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
                <% } else { %>
                <a href="javascript:void(0)" onclick="navTo('login')" class="logout-btn" style="background: var(--primary); color: white;"><i class="fa-solid fa-right-to-bracket"></i> Login</a>
                <% }%>
            </div>
        </nav>

        <div class="container">
            <!-- Hero Section -->
            <div class="hero-card">
                <div class="hero-left">
                    <div style="background: rgba(255,255,255,0.2); display: inline-block; padding: 0.25rem 0.75rem; border-radius: 1rem; font-size: 0.8rem; margin-bottom: 1rem;">
                        Welcome Back 👋
                    </div>
                    <h1>Hello, <%= userName%></h1>
                    <p>Manage your car wash bookings, track your vehicle cleaning progress, collect loyalty rewards, and enjoy premium membership benefits all in one smart dashboard.</p>
                    <div class="hero-actions">
                        <button class="btn-primary" onclick="navTo('booking')">Quick Booking</button>
                        <button class="btn-outline">View Promotions</button>
                    </div>
                </div>
                <div class="hero-right">
                    <div style="font-size: 0.9rem; margin-bottom: 0.5rem;">Membership Tier</div>
                    <div class="tier-badge tier-<%= tierName.replace(" member", "")%>"><%= tierName.replace(" member", "").toUpperCase()%></div>
                    <div class="points"><%= String.format("%,d", currentPoints)%></div>
                    <div class="points-label">Loyalty Points Available</div>
                </div>
            </div>

            <!-- Left Column -->
            <div class="left-col">
                <div class="section-title">
                    Available Services <a href="#">See All</a>
                </div>
                <div class="services-grid">
                    <% if (serviceList != null && !serviceList.isEmpty()) { %>
                        <% for (Service service : serviceList) { %>
                            <div class="card card-service">
                                <div class="service-icon"><i class="fa-solid fa-car"></i></div>
                                <div class="service-name"><%= service.getServiceName() %></div>
                                <div class="service-desc"><%= service.getDescription() != null ? service.getDescription() : "" %></div>
                                <div class="service-price"><%= service.getPrice() != null ? String.format("%,.0f", service.getPrice().doubleValue()) : "0" %>đ</div>
                            </div>
                        <% } %>
                    <% } else { %>
                        <div class="card card-service" style="background: #f8fafc; border-color: #cbd5e1;">
                            <div class="service-icon"><i class="fa-solid fa-ban"></i></div>
                            <div class="service-name">No active services</div>
                            <div class="service-desc">Currently there are no active service packages available.</div>
                            <div class="service-price">N/A</div>
                        </div>
                    <% } %>
                </div>

                <div class="offer-banner">
                    <div style="background: rgba(255,255,255,0.3); display: inline-block; padding: 0.25rem 0.75rem; border-radius: 1rem; font-size: 0.7rem; font-weight: 700; margin-bottom: 0.5rem;">LIMITED OFFER</div>
                    <h2 style="font-size: 1.5rem; margin-bottom: 0.5rem;">20% OFF Premium Wash</h2>
                    <p style="font-size: 0.85rem; margin-bottom: 1rem; opacity: 0.9;">Use voucher code GOLD20 and earn double loyalty points for all premium bookings this week.</p>
                    <button style="background: white; color: #06b6d4; border: none; padding: 0.5rem 1rem; border-radius: 0.5rem; font-weight: 700; cursor: pointer;">Claim Voucher</button>
                </div>
            </div>

            <!-- Right Column -->
            <div class="right-col">
                <div class="card" style="margin-bottom: 1.5rem;">
                    <div class="section-title">Vehicle Status</div>
                    <div class="status-stepper">
                        <div class="step">
                            <div class="step-number">1</div>
                            <div class="step-info">
                                <h4>Vehicle Checked In</h4>
                                <p>Your car has arrived at the washing station.</p>
                            </div>
                        </div>
                        <div class="step active">
                            <div class="step-number">2</div>
                            <div class="step-info">
                                <h4 style="color: var(--primary);">Exterior Washing</h4>
                                <p>High-pressure cleaning and foam wash in progress.</p>
                            </div>
                        </div>
                        <div class="step">
                            <div class="step-number" style="background: #e5e7eb; color: #9ca3af;">3</div>
                            <div class="step-info">
                                <h4 style="color: #9ca3af;">Drying & Finishing</h4>
                                <p>Estimated completion in 15 minutes.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="section-title">Loyalty Rewards</div>
                    <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem; border-bottom: 1px solid var(--border); padding-bottom: 1rem;">
                        <div>
                            <div style="font-weight: 700; font-size: 0.9rem; color: var(--primary);">Current Points</div>
                            <div style="font-size: 0.75rem; color: var(--text-muted);">Earn more by booking</div>
                        </div>
                        <div style="font-weight: 800;"><%=(customer != null ? customer.getCurrentPoints() : "2,450")%></div>
                    </div>
                    <div style="display: flex; justify-content: space-between; padding-top: 1rem;">
                        <div>
                            <div style="font-weight: 700; font-size: 0.9rem; color: var(--primary);">Free Wash Reward</div>
                            <div style="font-size: 0.75rem; color: var(--text-muted);">Unlock at 3,000 points</div>
                        </div>
                        <div style="font-weight: 800;">81%</div>
                    </div>
                </div>
            </div>

            <!-- Bottom Banner -->
            <div class="bottom-banner">
                <div>
                    <h2 style="font-size: 1.8rem; margin-bottom: 0.5rem;">Drive Clean. Drive Premium.</h2>
                    <p style="color: #94a3b8; font-size: 0.9rem; max-width: 500px;">Enjoy AI-powered booking, premium car care services, loyalty rewards, and exclusive membership benefits with AutoWash Pro Dashboard.</p>
                </div>
                <button class="btn-primary" style="background: #06b6d4;" onclick="navTo('booking')">Book Service Now</button>
            </div>
        </div>

        <form id="postNavForm" action="main" method="POST" style="display:none;">
            <input type="hidden" name="action" id="postNavAction">
        </form>
        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

        <% if (acc != null) { %>
            <!-- ═══ Messenger-Style Chat Widget ═══ -->

            <!-- FAB Button -->
            <button class="chat-fab" id="chatFab" onclick="toggleChat()">
                <i class="fa-brands fa-facebook-messenger"></i>
                <span class="chat-fab-badge" id="chatBadge">0</span>
            </button>

            <!-- Chat Popup -->
            <div class="chat-popup" id="chatPopup">
                <!-- Header -->
                <div class="chat-popup-header">
                    <div class="chat-popup-header-left">
                        <div class="chat-popup-avatar">
                            <i class="fa-solid fa-headset"></i>
                            <span class="online-dot"></span>
                        </div>
                        <div>
                            <div class="chat-popup-title">AutoWash Support</div>
                            <div class="chat-popup-subtitle">Usually replies instantly</div>
                        </div>
                    </div>
                    <button class="chat-popup-close" onclick="toggleChat()">
                        <i class="fa-solid fa-xmark"></i>
                    </button>
                </div>

                <!-- Messages -->
                <div class="chat-messages-area" id="chatMessages">
                    <div class="chat-welcome">
                        <i class="fa-brands fa-facebook-messenger"></i>
                        <strong>Welcome to AutoWash Support!</strong><br>
                        How can we help you today?
                    </div>
                </div>

                <!-- Typing Indicator -->
                <div class="typing-indicator" id="typingIndicator">
                    <span class="typing-dot"></span>
                    <span class="typing-dot"></span>
                    <span class="typing-dot"></span>
                </div>

                <!-- Input Bar -->
                <div class="chat-input-bar">
                    <input type="text" class="chat-input-field" id="chatInput"
                           placeholder="Aa" autocomplete="off"
                           onkeypress="if(event.key === 'Enter') sendChatMessage()">
                    <button class="chat-send-btn" id="chatSendBtn" onclick="sendChatMessage()">
                        <i class="fa-solid fa-paper-plane"></i>
                    </button>
                </div>
            </div>

            <script>
                // ═══ Customer Chat WebSocket ═══
                let chatWs = null;
                let myAccountId = '<%= acc.getAccountID() %>';
                let chatIsOpen = false;
                let unreadCount = 0;
                let lastSender = null;

                function toggleChat() {
                    let popup = document.getElementById('chatPopup');
                    if (!chatIsOpen) {
                        popup.classList.remove('closing');
                        popup.classList.add('open');
                        chatIsOpen = true;
                        // Reset unread
                        unreadCount = 0;
                        updateBadge();
                        // Connect if needed
                        if (!chatWs || chatWs.readyState !== WebSocket.OPEN) {
                            initWebSocket();
                        }
                        document.getElementById('chatInput').focus();
                    } else {
                        popup.classList.add('closing');
                        setTimeout(function() {
                            popup.classList.remove('open', 'closing');
                            chatIsOpen = false;
                        }, 200);
                    }
                }

                function initWebSocket() {
                    let wsProtocol = window.location.protocol === "https:" ? "wss://" : "ws://";
                    let wsUrl = wsProtocol + window.location.host
                              + "${pageContext.request.contextPath}/chat/" + myAccountId;
                    chatWs = new WebSocket(wsUrl);

                    chatWs.onopen = function() {
                        console.log("[Chat] Connected as accountId=" + myAccountId);
                    };

                    chatWs.onmessage = function(event) {
                        let msg = event.data;
                        let idx = msg.indexOf("|");
                        if (idx <= 0) return;

                        let sender = msg.substring(0, idx);
                        let text = msg.substring(idx + 1);
                        let isMe = (sender === "ME");

                        appendMessage(text, isMe);

                        if (!isMe && !chatIsOpen) {
                            unreadCount++;
                            updateBadge();
                        }
                    };

                    chatWs.onclose = function() {
                        console.log("[Chat] Disconnected");
                    };

                    chatWs.onerror = function(err) {
                        console.error("[Chat] Error:", err);
                    };
                }

                function appendMessage(text, isMe) {
                    let container = document.getElementById('chatMessages');

                    // Remove welcome message on first real message
                    let welcome = container.querySelector('.chat-welcome');
                    if (welcome) welcome.remove();

                    // Message row
                    let row = document.createElement('div');
                    row.className = 'msg-row ' + (isMe ? 'mine' : 'theirs');

                    // Avatar (only for received messages)
                    if (!isMe) {
                        let avatar = document.createElement('div');
                        avatar.className = 'msg-avatar-small';
                        avatar.innerHTML = '<i class="fa-solid fa-headset"></i>';
                        row.appendChild(avatar);
                    }

                    // Bubble wrapper
                    let bubbleWrap = document.createElement('div');

                    let bubble = document.createElement('div');
                    bubble.className = 'msg-bubble ' + (isMe ? 'mine' : 'theirs');
                    bubble.textContent = text;
                    bubbleWrap.appendChild(bubble);

                    // Timestamp
                    let time = document.createElement('div');
                    time.className = 'msg-time';
                    let now = new Date();
                    time.textContent = now.getHours().toString().padStart(2, '0') + ':'
                                     + now.getMinutes().toString().padStart(2, '0');
                    bubbleWrap.appendChild(time);

                    row.appendChild(bubbleWrap);
                    container.appendChild(row);
                    container.scrollTop = container.scrollHeight;

                    lastSender = isMe ? 'me' : 'them';
                }

                function sendChatMessage() {
                    let input = document.getElementById('chatInput');
                    let text = input.value.trim();
                    if (text === '') return;

                    if (chatWs && chatWs.readyState === WebSocket.OPEN) {
                        // Send to Admin (ID = 1)
                        chatWs.send("1|" + text);
                        input.value = '';
                        input.focus();
                    } else {
                        // Try reconnecting
                        initWebSocket();
                        setTimeout(function() {
                            if (chatWs && chatWs.readyState === WebSocket.OPEN) {
                                chatWs.send("1|" + text);
                                input.value = '';
                            } else {
                                alert("Cannot connect to chat. Please try again.");
                            }
                        }, 1000);
                    }
                }

                function updateBadge() {
                    let badge = document.getElementById('chatBadge');
                    if (unreadCount > 0) {
                        badge.textContent = unreadCount > 9 ? '9+' : unreadCount;
                        badge.classList.add('show');
                    } else {
                        badge.classList.remove('show');
                    }
                }
            </script>
        <% } %>

    </body>
</html>
