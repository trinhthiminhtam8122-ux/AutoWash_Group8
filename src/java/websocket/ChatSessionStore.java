package websocket;

import dto.Account;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Static store that maps HTTP Session IDs to Account objects.
 * 
 * Populated by WebSocketSessionFilter on every request.
 * Read by ChatEndpoint.onOpen() to authenticate WebSocket connections.
 * 
 * This approach is more reliable than passing HttpSession through
 * the WebSocket handshake, which fails on some Tomcat versions.
 */
public class ChatSessionStore {

    private static final Map<String, Account> sessionAccountMap = new ConcurrentHashMap<>();

    public static void putAccount(String httpSessionId, Account account) {
        if (httpSessionId != null && account != null) {
            sessionAccountMap.put(httpSessionId, account);
        }
    }

    public static Account getAccount(String httpSessionId) {
        if (httpSessionId == null) return null;
        return sessionAccountMap.get(httpSessionId);
    }

    public static void removeAccount(String httpSessionId) {
        if (httpSessionId != null) {
            sessionAccountMap.remove(httpSessionId);
        }
    }
}
