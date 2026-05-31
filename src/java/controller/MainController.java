package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "MainController", urlPatterns = {"/main"})
public class MainController extends HttpServlet {

    private static final String VIEW_DIR = "/WEB-INF/views/";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        // Nếu có parameter action trên URL (GET), lưu vào session và redirect để giấu URL
        if (action != null && !action.trim().isEmpty()) {
            session.setAttribute("CURRENT_VIEW", action);
            response.sendRedirect("main");
            return;
        }

        // Lấy action từ session, nếu không có thì mặc định là home
        action = (String) session.getAttribute("CURRENT_VIEW");
        if (action == null || action.trim().isEmpty()) {
            action = "home";
        }

        String viewPage;

        switch (action) {
            case "home":
            case "dashboard":
                viewPage = "dashboard.jsp";
                break;

            case "login":
                viewPage = "login.jsp";
                break;

            case "register":
                viewPage = "register.jsp";
                break;

            case "profile":
                // Kiểm tra đăng nhập trước khi vào trang profile
                if (session.getAttribute("LOGIN_USER") == null) {
                    session.setAttribute("CURRENT_VIEW", "login");
                    response.sendRedirect("main");
                    return;
                }
                viewPage = "profile.jsp";
                break;

            case "register-success":
                viewPage = "register_success.jsp";
                break;

            default:
                viewPage = "dashboard.jsp";
                break;
        }

        request.getRequestDispatcher(VIEW_DIR + viewPage).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nhận POST request từ các link điều hướng (giấu action)
        String action = request.getParameter("action");
        if (action != null && !action.trim().isEmpty()) {
            request.getSession().setAttribute("CURRENT_VIEW", action);
            response.sendRedirect("main"); // Áp dụng PRG để chống resubmit
        } else {
            doGet(request, response);
        }
    }
}
