<%@page import="dto.Staff"%>
<%@page import="dto.Account"%>
<%@ page import="java.util.List" %>
<%@ page import="dto.Booking" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html;charset=UTF-8");
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    
    Account acc = (Account) session.getAttribute("LOGIN_USER");
    Staff staff = (Staff) session.getAttribute("STAFF_INFO");
    String userName = (staff != null) ? staff.getFullName() : (acc != null ? acc.getUsername() : "Admin");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AutoWash Admin - Booking Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        :root {
            --sidebar-bg: #0f172a;
            --sidebar-text: #94a3b8;
            --sidebar-hover: #1e293b;
            --sidebar-active: #ffffff;
            --topbar-bg: #ffffff;
            --main-bg: #f8fafc;
            --primary: #3b82f6;
            --text-dark: #1e293b;
            --border: #e2e8f0;
            --success: #22c55e;
            --warning: #f59e0b;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            display: flex;
            height: 100vh;
            background-color: var(--main-bg);
            color: var(--text-dark);
            overflow: hidden;
        }

        /* SIDEBAR */
        .sidebar {
            width: 250px;
            background-color: var(--sidebar-bg);
            display: flex;
            flex-direction: column;
            color: var(--sidebar-text);
            transition: all 0.3s;
        }

        .sidebar-header {
            padding: 20px;
            text-align: center;
            font-size: 1.5rem;
            font-weight: 800;
            color: white;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .menu-label {
            padding: 20px 20px 10px;
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: rgba(255,255,255,0.5);
        }

        .menu-list {
            list-style: none;
            display: flex;
            flex-direction: column;
            flex: 1;
        }

        .menu-item {
            padding: 15px 25px;
            display: flex;
            align-items: center;
            gap: 15px;
            cursor: pointer;
            font-weight: 500;
            text-decoration: none;
            color: var(--sidebar-text);
            transition: 0.2s;
        }

        .menu-item:hover {
            background-color: var(--sidebar-hover);
            color: white;
        }

        .menu-item.active {
            color: white;
            font-weight: 600;
            border-left: 4px solid white;
            background-color: rgba(255,255,255,0.05);
        }

        .menu-item i {
            font-size: 1.2rem;
            width: 20px;
            text-align: center;
        }

        .sidebar-footer {
            padding: 20px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }

        .logout-link {
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--sidebar-text);
            text-decoration: none;
            font-weight: 500;
        }
        .logout-link:hover {
            color: white;
        }

        /* MAIN CONTENT */
        .main-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        /* TOPBAR */
        .topbar {
            height: 70px;
            background-color: var(--topbar-bg);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 30px;
            border-bottom: 1px solid var(--border);
            border-top: 4px solid #38bdf8;
        }

        .logo-area {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.8rem;
            font-weight: 800;
            color: black;
        }
        
        .logo-area i {
            color: #3b82f6;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-profile i {
            font-size: 1.5rem;
            color: #64748b;
        }

        /* CONTENT AREA */
        .content {
            flex: 1;
            padding: 30px;
            overflow-y: auto;
        }

        .page-title {
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 20px;
        }

        /* BOOKING MANAGEMENT STYLES */
        .toolbar {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }

        .search-input {
            padding: 10px 15px;
            border: 1px solid var(--border);
            border-radius: 6px;
            width: 300px;
            outline: none;
        }

        .status-filter {
            padding: 10px;
            border: 1px solid var(--border);
            border-radius: 6px;
            outline: none;
            background: white;
        }

        .btn-search {
            padding: 10px 25px;
            background-color: var(--primary);
            color: white;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
        }

        /* TABLE */
        .table-container {
            background: white;
            border-radius: 12px;
            padding: 10px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 15px 20px;
            text-align: left;
            border-bottom: 1px solid var(--border);
            font-size: 0.95rem;
        }

        th {
            font-weight: 700;
            color: #1e293b;
        }

        tr:last-child td {
            border-bottom: none;
        }

        /* BADGES */
        .badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
        }
        
        .badge.pending { background: #fef3c7; color: #d97706; }
        .badge.confirmed { background: #e0f2fe; color: #0284c7; }
        .badge.washing { background: #ede9fe; color: #7c3aed; }
        .badge.completed { background: #dcfce7; color: #16a34a; }
        .badge.cancelled { background: #fee2e2; color: #dc2626; }

        /* ACTION BUTTONS */
        .action-form {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .btn-action {
            padding: 6px 15px;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 600;
            border: none;
            cursor: pointer;
            color: white;
        }

        .btn-view { background-color: var(--primary); }
        .btn-update { background-color: var(--success); }
        
        .action-select {
            padding: 5px;
            border: 1px solid var(--border);
            border-radius: 4px;
            font-size: 0.85rem;
            outline: none;
        }

        /* ALERTS */
        .alert {
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 500;
        }
        .alert-success { background: #dcfce7; color: #16a34a; }
        .alert-error { background: #fee2e2; color: #dc2626; }

    </style>
</head>
<body>

    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="sidebar-header">
            AutoWash
        </div>
        <div class="menu-label">Menu</div>
        <div class="menu-list">
            <a href="${pageContext.request.contextPath}/main?action=dashboard" class="menu-item">
                <i class="fa-solid fa-house"></i> Dashboard
            </a>
            <a href="#" class="menu-item">
                <i class="fa-regular fa-user"></i> Customer
            </a>
            <a href="${pageContext.request.contextPath}/main?action=admin" class="menu-item active">
                <i class="fa-regular fa-calendar-check"></i> Booking
            </a>
            <a href="#" class="menu-item">
                <i class="fa-regular fa-heart"></i> Loyalty
            </a>
            <a href="#" class="menu-item">
                <i class="fa-solid fa-gift"></i> Promotions
            </a>
            <a href="#" class="menu-item">
                <i class="fa-solid fa-chart-line"></i> Reports
            </a>
        </div>
        <div class="sidebar-footer">
            <a href="${pageContext.request.contextPath}/LogoutController" class="logout-link">
                <i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
            </a>
        </div>
    </aside>

    <!-- MAIN WRAPPER -->
    <div class="main-wrapper">
        
        <!-- TOPBAR -->
        <header class="topbar">
            <div class="logo-area">
                <i class="fa-solid fa-car-burst"></i> AutoWash
            </div>
            <div class="user-profile">
                <i class="fa-regular fa-user"></i>
            </div>
        </header>

        <!-- CONTENT -->
        <main class="content">
            <h1 class="page-title">Booking Management</h1>

            <% String successMsg = (String) session.getAttribute("SUCCESS_MSG");
               if (successMsg != null) { 
                   session.removeAttribute("SUCCESS_MSG");
            %>
            <div class="alert alert-success">
                <i class="fa-solid fa-circle-check"></i> <%= successMsg %>
            </div>
            <% } %>
            
            <% String errorMsg = (String) session.getAttribute("ERROR_MSG");
               if (errorMsg != null) { 
                   session.removeAttribute("ERROR_MSG");
            %>
            <div class="alert alert-error">
                <i class="fa-solid fa-circle-xmark"></i> <%= errorMsg %>
            </div>
            <% } %>

            <div class="toolbar">
                <input type="text" class="search-input" placeholder="Search booking / customer" />
                <select class="status-filter">
                    <option>All Status</option>
                    <option>Pending</option>
                    <option>Confirmed</option>
                    <option>Washing</option>
                    <option>Completed</option>
                    <option>Cancelled</option>
                </select>
                <button class="btn-search">Search</button>
            </div>

            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Booking ID</th>
                            <th>Customer</th>
                            <th>Vehicle</th>
                            <th>Service</th>
                            <th>Date & Time</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (bookings == null || bookings.isEmpty()) { %>
                            <tr>
                                <td colspan="7" style="text-align: center; padding: 30px;">No bookings found in the system.</td>
                            </tr>
                        <% } else { 
                            for (Booking b : bookings) { 
                                String currentStatus = b.getStatus() != null ? b.getStatus() : "Pending";
                                String statusClass = currentStatus.toLowerCase();
                                String dateTimeStr = (b.getScheduledDate() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(b.getScheduledDate()) : "N/A") + " - " + 
                                                     (b.getScheduledTime() != null ? String.format("%tR", b.getScheduledTime()) : "N/A");
                        %>
                            <tr>
                                <td>B<%= String.format("%03d", b.getBookingID()) %></td>
                                <td><%= b.getCustomerNameSnapshot() %></td>
                                <td><%= b.getVehiclePlateSnapshot() %></td>
                                <td><%= b.getServiceType() %></td>
                                <td><%= dateTimeStr %></td>
                                <td><span class="badge <%= statusClass %>"><%= currentStatus %></span></td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/AdminController" method="POST" class="action-form">
                                        <input type="hidden" name="action" value="updateStatus">
                                        <input type="hidden" name="bookingID" value="<%= b.getBookingID() %>">
                                        
                                        <select name="status" class="action-select">
                                            <option value="Pending" <%= "Pending".equals(currentStatus) ? "selected" : "" %>>Pending</option>
                                            <option value="Confirmed" <%= "Confirmed".equals(currentStatus) ? "selected" : "" %>>Confirmed</option>
                                            <option value="Washing" <%= "Washing".equals(currentStatus) ? "selected" : "" %>>Washing</option>
                                            <option value="Completed" <%= "Completed".equals(currentStatus) ? "selected" : "" %>>Completed</option>
                                            <option value="Cancelled" <%= "Cancelled".equals(currentStatus) ? "selected" : "" %>>Cancelled</option>
                                        </select>
                                        
                                        <button type="button" class="btn-action btn-view" title="View Details">View</button>
                                        <button type="submit" class="btn-action btn-update">Update</button>
                                    </form>
                                </td>
                            </tr>
                        <%  }
                        } %>
                    </tbody>
                </table>
            </div>
            
            <!-- FOOTER INFO -->
            <div style="margin-top: 50px; padding: 20px; background: var(--sidebar-bg); color: white; border-radius: 8px; display: flex; justify-content: space-between; font-size: 0.85rem;">
                <div style="display:flex; align-items:center; gap: 10px;">
                    <i class="fa-solid fa-location-dot"></i> Lô E2a-7, Đường D1, KCNC, TP Thủ Đức
                </div>
                <div style="display:flex; align-items:center; gap: 10px;">
                    <i class="fa-solid fa-phone"></i> 0123456789
                </div>
                <div style="display:flex; align-items:center; gap: 10px;">
                    <i class="fa-solid fa-envelope"></i> carwash@gmail.com
                </div>
            </div>

        </main>
    </div>

    <!-- ═══ Admin Messenger-Style Chat Widget ═══ -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/messenger-chat.css">
    <%@page import="dao.CustomerDAO"%>
    <%@page import="dto.Customer"%>
    <%@page import="java.util.List"%>
    <% 
       // Admin luôn kết nối WebSocket với ID = "1" (kênh hỗ trợ cố định)
       // vì Customer bên dashboard.jsp hardcode gửi tới ID = 1
       String adminId = "1";
       
       CustomerDAO cusDaoChat = new CustomerDAO();
       List<Customer> allCustomersForChat = cusDaoChat.getAllCustomers();
    %>

    <!-- FAB Button -->
    <button class="chat-fab" id="adminChatFab" onclick="toggleAdminChat()">
        <i class="fa-brands fa-facebook-messenger"></i>
        <span class="chat-fab-badge" id="adminChatBadge">0</span>
    </button>

    <!-- Admin Chat Popup -->
    <div class="admin-chat-popup" id="adminChatPopup">
        
        <!-- LEFT: User List Sidebar -->
        <div class="chat-user-sidebar">
            <div class="chat-user-sidebar-header">Chats</div>
            <div class="chat-user-list" id="userListContainer">
                <div class="chat-user-empty" id="emptyUsersMsg">
                    <i class="fa-regular fa-comments"></i>
                    No active chats
                </div>
            </div>
        </div>

        <!-- RIGHT: Chat Main Area -->
        <div class="chat-main-area">
            <!-- Header -->
            <div class="chat-main-header">
                <div class="chat-main-header-left" id="chatMainHeaderLeft">
                    <div class="chat-main-header-avatar" id="chatHeaderAvatar" style="display:none;">
                        <i class="fa-solid fa-user"></i>
                    </div>
                    <div>
                        <div class="chat-main-header-name" id="chatHeaderTitle">Select a chat</div>
                        <div class="chat-main-header-status" id="chatHeaderStatus"></div>
                    </div>
                </div>
                <button class="chat-main-close" onclick="toggleAdminChat()">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>
            
            <!-- Messages Area -->
            <div class="chat-messages-area" id="adminChatMessages">
                <div class="chat-empty-state" id="chatEmptyState">
                    <i class="fa-regular fa-comments"></i>
                    <p>Select a conversation to start messaging</p>
                </div>
            </div>
            
            <!-- Input Bar -->
            <div class="chat-input-bar">
                <input type="text" class="chat-input-field" id="adminChatInput"
                       placeholder="Aa" disabled autocomplete="off"
                       onkeypress="if(event.key === 'Enter') sendAdminMessage()">
                <button class="chat-send-btn" id="adminSendBtn" disabled onclick="sendAdminMessage()">
                    <i class="fa-solid fa-paper-plane"></i>
                </button>
            </div>
        </div>

    </div>

    <script>
        // ═══ Admin Chat WebSocket ═══
        let adminWs = null;
        let myAdminId = '<%= adminId %>';
        let adminChatIsOpen = false;
        let totalUnread = 0;
        
        // Customer data from database
        let customerAvatars = {};
        let customerNames = {};
        <% if (allCustomersForChat != null) {
               for (Customer c : allCustomersForChat) { 
                   String cName = c.getFullName() != null ? c.getFullName().replace("\"", "\\\"") : "Client";
        %>
                   customerNames["<%= c.getAccountID() %>"] = "<%= cName %>";
        <%
                   if (c.getAvatarUrl() != null && !c.getAvatarUrl().isEmpty()) {
                       String url = request.getContextPath() + (c.getAvatarUrl().startsWith("/") ? "" : "/") + c.getAvatarUrl();
        %>
                       customerAvatars["<%= c.getAccountID() %>"] = "<%= url %>";
        <%         }
               }
           } %>
        
        // State
        let conversations = {};   // { "5": [{isMe:false, text:"hi", time:"14:30"}, ...] }
        let unreadCounts = {};    // { "5": 3, "7": 1 }
        let activeClientId = null;
        
        function toggleAdminChat() {
            let popup = document.getElementById('adminChatPopup');
            if (!adminChatIsOpen) {
                popup.classList.remove('closing');
                popup.classList.add('open');
                adminChatIsOpen = true;
                if (!adminWs || adminWs.readyState !== WebSocket.OPEN) {
                    initAdminWebSocket();
                }
                updateAdminUI();
            } else {
                popup.classList.add('closing');
                setTimeout(function() {
                    popup.classList.remove('open', 'closing');
                    adminChatIsOpen = false;
                }, 200);
            }
        }
        
        function initAdminWebSocket() {
            let wsProtocol = window.location.protocol === "https:" ? "wss://" : "ws://";
            let wsUrl = wsProtocol + window.location.host
                      + "${pageContext.request.contextPath}/chat/" + myAdminId;
            adminWs = new WebSocket(wsUrl);
            
            adminWs.onopen = function() {
                console.log("[AdminChat] Connected as accountId=" + myAdminId);
            };
            
            adminWs.onmessage = function(event) {
                let msg = event.data;
                let idx = msg.indexOf("|");
                if (idx <= 0) return;
                
                let sender = msg.substring(0, idx);
                let text = msg.substring(idx + 1);
                
                if (sender === "ME") return; // Ignore echo, we append locally
                
                // Get timestamp
                let now = new Date();
                let timeStr = now.getHours().toString().padStart(2, '0') + ':'
                            + now.getMinutes().toString().padStart(2, '0');
                
                if (!conversations[sender]) {
                    conversations[sender] = [];
                    unreadCounts[sender] = 0;
                }
                conversations[sender].push({isMe: false, text: text, time: timeStr});
                
                // Unread count
                if (sender !== activeClientId) {
                    unreadCounts[sender] = (unreadCounts[sender] || 0) + 1;
                    totalUnread++;
                    updateAdminBadge();
                }
                
                // Auto-select first person
                if (activeClientId === null) {
                    activeClientId = sender;
                }
                
                updateAdminUI();
            };
            
            adminWs.onclose = function() {
                console.log("[AdminChat] Disconnected");
            };
            
            adminWs.onerror = function(err) {
                console.error("[AdminChat] Error:", err);
            };
        }
        
        function selectClient(clientId) {
            activeClientId = clientId;
            // Reset unread for this client
            if (unreadCounts[clientId]) {
                totalUnread -= unreadCounts[clientId];
                if (totalUnread < 0) totalUnread = 0;
                unreadCounts[clientId] = 0;
                updateAdminBadge();
            }
            updateAdminUI();
        }

        function getInitials(name) {
            if (!name) return '?';
            let parts = name.trim().split(' ');
            if (parts.length >= 2) {
                return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
            }
            return name[0].toUpperCase();
        }

        function updateAdminUI() {
            // ── 1. Render User List ──
            let userListContainer = document.getElementById('userListContainer');
            let clientIds = Object.keys(conversations);
            
            if (clientIds.length === 0) {
                userListContainer.innerHTML = '<div class="chat-user-empty"><i class="fa-regular fa-comments"></i>No active chats</div>';
            } else {
                userListContainer.innerHTML = '';
                clientIds.forEach(function(id) {
                    let div = document.createElement('div');
                    div.className = 'user-item' + (id === activeClientId ? ' active' : '');
                    div.onclick = function() { selectClient(id); };
                    
                    let clientName = customerNames[id] || ('Client ' + id);
                    if (clientName === 'Client') clientName = 'Client ' + id;
                    let avatarSrc = customerAvatars[id];
                    let msgs = conversations[id] || [];
                    let lastMsg = msgs.length > 0 ? msgs[msgs.length - 1].text : '';
                    if (lastMsg.length > 28) lastMsg = lastMsg.substring(0, 28) + '...';
                    let unread = unreadCounts[id] || 0;
                    
                    // Avatar
                    let avatarHtml = '';
                    if (avatarSrc) {
                        avatarHtml = '<div class="user-item-avatar">'
                                   + '<img src="' + avatarSrc + '" onerror="this.style.display=\'none\'; this.parentElement.textContent=\'' + getInitials(clientName) + '\';">'
                                   + '<span class="user-online-dot"></span>'
                                   + '</div>';
                    } else {
                        avatarHtml = '<div class="user-item-avatar">'
                                   + getInitials(clientName)
                                   + '<span class="user-online-dot"></span>'
                                   + '</div>';
                    }
                    
                    let unreadBadgeHtml = '<span class="user-item-unread' + (unread > 0 ? ' show' : '') + '">' + unread + '</span>';
                    
                    div.innerHTML = avatarHtml
                        + '<div class="user-item-info">'
                        +   '<div class="user-item-name">' + clientName + '</div>'
                        +   '<div class="user-item-last-msg' + (unread > 0 ? ' unread' : '') + '">' + lastMsg + '</div>'
                        + '</div>'
                        + unreadBadgeHtml;
                    
                    userListContainer.appendChild(div);
                });
            }

            // ── 2. Render Chat Area ──
            let headerTitle = document.getElementById('chatHeaderTitle');
            let headerStatus = document.getElementById('chatHeaderStatus');
            let headerAvatar = document.getElementById('chatHeaderAvatar');
            let messagesContainer = document.getElementById('adminChatMessages');
            let emptyState = document.getElementById('chatEmptyState');
            let inputField = document.getElementById('adminChatInput');
            let sendBtn = document.getElementById('adminSendBtn');

            if (activeClientId === null) {
                headerTitle.textContent = 'Select a chat';
                headerStatus.textContent = '';
                headerAvatar.style.display = 'none';
                inputField.disabled = true;
                sendBtn.disabled = true;
                messagesContainer.innerHTML = '<div class="chat-empty-state"><i class="fa-regular fa-comments"></i><p>Select a conversation to start messaging</p></div>';
            } else {
                let headerName = customerNames[activeClientId] || ('Client ' + activeClientId);
                headerTitle.textContent = headerName;
                headerStatus.textContent = 'Active now';
                
                // Show header avatar
                headerAvatar.style.display = 'flex';
                let hAvatarSrc = customerAvatars[activeClientId];
                if (hAvatarSrc) {
                    headerAvatar.innerHTML = '<img src="' + hAvatarSrc + '" onerror="this.style.display=\'none\'; this.parentElement.innerHTML=\'<i class=fa-solid fa-user></i>\';">';
                } else {
                    headerAvatar.innerHTML = getInitials(headerName);
                }
                
                inputField.disabled = false;
                sendBtn.disabled = false;

                // Render messages
                messagesContainer.innerHTML = '';
                let history = conversations[activeClientId] || [];
                
                history.forEach(function(msg, index) {
                    let row = document.createElement('div');
                    row.className = 'msg-row ' + (msg.isMe ? 'mine' : 'theirs');

                    // Avatar for received messages
                    if (!msg.isMe) {
                        let avatar = document.createElement('div');
                        avatar.className = 'msg-avatar-small';
                        let aSrc = customerAvatars[activeClientId];
                        if (aSrc) {
                            avatar.innerHTML = '<img src="' + aSrc + '">';
                        } else {
                            avatar.innerHTML = '<i class="fa-solid fa-user"></i>';
                        }
                        row.appendChild(avatar);
                    }

                    let bubbleWrap = document.createElement('div');

                    let bubble = document.createElement('div');
                    bubble.className = 'msg-bubble ' + (msg.isMe ? 'mine' : 'theirs');
                    bubble.textContent = msg.text;
                    bubbleWrap.appendChild(bubble);

                    // Timestamp
                    let time = document.createElement('div');
                    time.className = 'msg-time';
                    time.textContent = msg.time || '';
                    bubbleWrap.appendChild(time);

                    row.appendChild(bubbleWrap);
                    messagesContainer.appendChild(row);
                });

                messagesContainer.scrollTop = messagesContainer.scrollHeight;
                inputField.focus();
            }
        }
        
        function sendAdminMessage() {
            let input = document.getElementById('adminChatInput');
            let text = input.value.trim();
            
            if (activeClientId === null || text === '') return;
            
            if (adminWs && adminWs.readyState === WebSocket.OPEN) {
                adminWs.send(activeClientId + "|" + text);
                
                // Get timestamp
                let now = new Date();
                let timeStr = now.getHours().toString().padStart(2, '0') + ':'
                            + now.getMinutes().toString().padStart(2, '0');
                
                // Append locally
                if (!conversations[activeClientId]) conversations[activeClientId] = [];
                conversations[activeClientId].push({isMe: true, text: text, time: timeStr});
                
                input.value = '';
                updateAdminUI();
            } else {
                initAdminWebSocket();
                setTimeout(function() {
                    if (adminWs && adminWs.readyState === WebSocket.OPEN) {
                        adminWs.send(activeClientId + "|" + text);
                        let now = new Date();
                        let timeStr = now.getHours().toString().padStart(2, '0') + ':'
                                    + now.getMinutes().toString().padStart(2, '0');
                        if (!conversations[activeClientId]) conversations[activeClientId] = [];
                        conversations[activeClientId].push({isMe: true, text: text, time: timeStr});
                        input.value = '';
                        updateAdminUI();
                    } else {
                        alert("Cannot connect to chat. Please try again.");
                    }
                }, 1000);
            }
        }
        
        function updateAdminBadge() {
            let badge = document.getElementById('adminChatBadge');
            if (totalUnread > 0) {
                badge.textContent = totalUnread > 9 ? '9+' : totalUnread;
                badge.classList.add('show');
            } else {
                badge.classList.remove('show');
            }
        }
    </script>

</body>
</html>

