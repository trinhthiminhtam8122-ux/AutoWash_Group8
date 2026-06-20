package controller;

import dao.VehicleDAO;
import dto.Customer;
import dto.Vehicle;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Scanner;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet(name = "VehicleController", urlPatterns = { "/VehicleController" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class VehicleController extends HttpServlet {

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String token : contentDisp.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }

    private String saveFileAndGetUrl(Part part) throws IOException {
        String fileName = getFileName(part);
        if (fileName == null || fileName.trim().isEmpty()) {
            return null;
        }

        String uploadFilePath = "D:" + File.separator + "auto_wash_uploads";
        File fileSaveDir = new File(uploadFilePath);
        if (!fileSaveDir.exists()) {
            fileSaveDir.mkdirs();
        }

        String uniqueFileName = UUID.randomUUID().toString() + "_" + Paths.get(fileName).getFileName().toString();
        part.write(uploadFilePath + File.separator + uniqueFileName);

        return "uploads/" + uniqueFileName;
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

        // Initialize multipart parsing if needed
        try {
            if (request.getContentType() != null && request.getContentType().toLowerCase().startsWith("multipart/")) {
                request.getParts();
            }
        } catch (Exception e) {
            log("Multipart parsing error: " + e.getMessage());
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("main?action=profile");
            return;
        }

        try {
            VehicleDAO vehicleDAO = new VehicleDAO();

            if ("delete".equals(action)) {
                int vehicleID = Integer.parseInt(request.getParameter("id"));
                vehicleDAO.deleteVehicle(vehicleID, customer.getCustomerID());
                session.setAttribute("SUCCESS_MSG", "Vehicle deleted successfully!");
                session.setAttribute("CURRENT_VIEW", "profile");
                response.sendRedirect("main");
            } else if ("add".equals(action) || "edit".equals(action)) {
                String licensePlate = request.getParameter("licensePlate");
                String brand = request.getParameter("brand");
                String model = request.getParameter("model");
                String vehicleType = request.getParameter("vehicleType");
                String color = request.getParameter("color");

                // Normalize license plate before any check or save
                licensePlate = licensePlate == null ? "" : licensePlate.trim().toUpperCase();

                // Combine brand, model, and type into VehicleModel field for now
                String fullModel = brand + " " + model + " - " + vehicleType;

                Vehicle vehicle = new Vehicle();
                vehicle.setCustomerID(customer.getCustomerID());
                vehicle.setLicensePlate(licensePlate);
                vehicle.setVehicleModel(fullModel);
                vehicle.setColor(color);

                // Handle image upload
                String vehicleImageUrl = null;
                Part vehicleImagePart = request.getPart("vehicleImage");
                if (vehicleImagePart != null && vehicleImagePart.getSize() > 0) {
                    vehicleImageUrl = saveFileAndGetUrl(vehicleImagePart);
                }

                if ("add".equals(action)) {
                    // Kiểm tra xem xe đã tồn tại hay chưa
                    if (vehicleDAO.checkLicensePlateExist(licensePlate)) {
                        session.setAttribute("ERROR_MSG", "This vehicle is already registered.");
                        session.setAttribute("CURRENT_VIEW", "profile");
                        response.sendRedirect("main");
                        return;
                    }

                    if (vehicleImageUrl == null) {
                        vehicleImageUrl = "/assets/images/default-car.png";
                    }
                    vehicle.setVehicleImageUrl(vehicleImageUrl);

                    boolean isSuccess = vehicleDAO.insertVehicle(vehicle);
                    if (isSuccess) {
                        session.setAttribute("SUCCESS_MSG", "Vehicle added successfully!");
                    } else {
                        session.setAttribute("ERROR_MSG", "Failed to add vehicle.");
                    }
                } else if ("edit".equals(action)) {
                    int vehicleID = Integer.parseInt(request.getParameter("vehicleID"));

                    // Kiểm tra xem biển số mới có bị trùng với xe khác đang active không
                    if (vehicleDAO.checkLicensePlateExistExclude(licensePlate, vehicleID)) {
                        session.setAttribute("ERROR_MSG", "This vehicle is already registered.");
                        session.setAttribute("CURRENT_VIEW", "profile");
                        response.sendRedirect("main");
                        return;
                    }

                        vehicle.setVehicleID(vehicleID);

                    if (vehicleImageUrl != null) {
                        vehicle.setVehicleImageUrl(vehicleImageUrl);
                    } else {
                        // Keep old image
                        String oldImage = request.getParameter("oldImage");
                        vehicle.setVehicleImageUrl(
                                oldImage != null && !oldImage.isEmpty() ? oldImage : "/assets/images/default-car.png");
                    }
                    boolean isUpdated = vehicleDAO.updateVehicle(vehicle);
                    if (isUpdated) {
                        session.setAttribute("SUCCESS_MSG", "Vehicle updated successfully!");
                    } else {    
                        session.setAttribute("ERROR_MSG", "Failed to update vehicle.");
                    }
                }

                session.setAttribute("CURRENT_VIEW", "profile");
                response.sendRedirect("main");
            }
        } catch (Exception e) {
            log("Error in VehicleController: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("ERROR_MSG", "An error occurred: " + e.getMessage());
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
