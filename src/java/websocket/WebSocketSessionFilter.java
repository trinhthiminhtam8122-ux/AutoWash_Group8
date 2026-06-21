package websocket;

import dto.Account;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * Filter that syncs the logged-in Account into ChatSessionStore
 * on every HTTP request. This ensures that when a WebSocket connection
 * is opened with ?sid=sessionId, the ChatEndpoint can look up the Account.
 */
@WebFilter(urlPatterns = "/*")
public class WebSocketSessionFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        if (request instanceof HttpServletRequest) {
            HttpServletRequest httpReq = (HttpServletRequest) request;
            HttpSession session = httpReq.getSession(false);
            if (session != null) {
                Account account = (Account) session.getAttribute("LOGIN_USER");
                if (account != null) {
                    ChatSessionStore.putAccount(session.getId(), account);
                }
            }
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
