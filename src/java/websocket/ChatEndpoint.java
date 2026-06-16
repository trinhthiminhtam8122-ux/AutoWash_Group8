package websocket;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

/**
 * WebSocket Chat Endpoint - Xử lý kết nối chat realtime.
 *
 * URL: /chat/{accountId}
 * Message format:
 *   Client gửi:     "receiverAccountId|messageText"
 *   Server gửi cho receiver: "senderAccountId|messageText"
 *   Server echo cho sender:  "ME|messageText"
 */
@ServerEndpoint("/chat/{accountId}")
public class ChatEndpoint {

    // Map lưu tất cả sessions: accountId -> WebSocket Session
    private static final Map<String, Session> sessions = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session, @PathParam("accountId") String accountId) {
        sessions.put(accountId, session);
        System.out.println("[ChatEndpoint] Connected: accountId=" + accountId
                + ", total sessions=" + sessions.size());
    }

    @OnMessage
    public void onMessage(String message, Session session,
                          @PathParam("accountId") String senderId) {
        try {
            // Message format: "receiverId|messageText"
            int separatorIndex = message.indexOf("|");
            if (separatorIndex <= 0) {
                System.out.println("[ChatEndpoint] Invalid message format from " + senderId + ": " + message);
                return;
            }

            String receiverId = message.substring(0, separatorIndex).trim();
            String text = message.substring(separatorIndex + 1);

            // 1. Gửi cho receiver: "senderId|text"
            Session receiverSession = sessions.get(receiverId);
            if (receiverSession != null && receiverSession.isOpen()) {
                receiverSession.getBasicRemote().sendText(senderId + "|" + text);
            }

            // 2. Echo cho sender: "ME|text" (để client xác nhận đã gửi)
            if (session.isOpen()) {
                session.getBasicRemote().sendText("ME|" + text);
            }

        } catch (IOException e) {
            System.err.println("[ChatEndpoint] Error sending message: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @OnClose
    public void onClose(Session session, @PathParam("accountId") String accountId) {
        sessions.remove(accountId);
        System.out.println("[ChatEndpoint] Disconnected: accountId=" + accountId
                + ", remaining sessions=" + sessions.size());
    }

    @OnError
    public void onError(Session session, Throwable throwable,
                        @PathParam("accountId") String accountId) {
        System.err.println("[ChatEndpoint] Error for accountId=" + accountId
                + ": " + throwable.getMessage());
        sessions.remove(accountId);
    }
}
