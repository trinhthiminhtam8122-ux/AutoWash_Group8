package controller;

import dao.CustomerDAO;
import dto.Customer;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet(name = "UpdateAvatarController", urlPatterns = {"/UpdateAvatarController"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class UpdateAvatarController extends HttpServlet {

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String token : contentDisp.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("CUSTOMER_INFO");
        
        if (customer == null) {
            session.setAttribute("CURRENT_VIEW", "login");
            response.sendRedirect("main");
            return;
        }

        try {
            Part avatarPart = request.getPart("avatarFile");
            String fileName = getFileName(avatarPart);
            
            if (fileName != null && !fileName.trim().isEmpty()) {
                String uploadFilePath = "D:" + File.separator + "auto_wash_uploads";
                File fileSaveDir = new File(uploadFilePath);
                if (!fileSaveDir.exists()) {
                    fileSaveDir.mkdirs();
                }
                
                String uniqueFileName = UUID.randomUUID().toString() + "_" + Paths.get(fileName).getFileName().toString();
                avatarPart.write(uploadFilePath + File.separator + uniqueFileName);
                
                String newAvatarUrl = "uploads/" + uniqueFileName;
                
                CustomerDAO dao = new CustomerDAO();
                boolean success = dao.updateAvatar(customer.getCustomerID(), newAvatarUrl);
                
                if (success) {
                    // Update session
                    customer.setAvatarUrl(newAvatarUrl);
                    session.setAttribute("CUSTOMER_INFO", customer);
                    session.setAttribute("SUCCESS_MSG", "Avatar updated successfully!");
                } else {
                    session.setAttribute("ERROR_MSG", "Failed to update avatar.");
                }
            }
            
            session.setAttribute("CURRENT_VIEW", "profile");
            response.sendRedirect("main");
            
        } catch (Exception e) {
            log("Error at UpdateAvatarController: " + e.toString());
            session.setAttribute("ERROR_MSG", "Upload failed. Please try again.");
            session.setAttribute("CURRENT_VIEW", "profile");
            response.sendRedirect("main");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
