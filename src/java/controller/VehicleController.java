package controller;

import dao.VehicleDAO;
import dto.Customer;
import dto.Vehicle;

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

        String action = getParameterValue(request, "action");
        if (action == null) {
            response.sendRedirect("main?action=profile");
            return;
        }

        try {
            VehicleDAO vehicleDAO = new VehicleDAO();

            if ("delete".equals(action)) {
                int vehicleID = Integer.parseInt(getParameterValue(request, "id"));
                vehicleDAO.deleteVehicle(vehicleID, customer.getCustomerID());
                session.setAttribute("SUCCESS_MSG", "Vehicle deleted successfully!");
                session.setAttribute("CURRENT_VIEW", "profile");
                response.sendRedirect("main");
            } else if ("add".equals(action) || "edit".equals(action)) {
                String licensePlate = getParameterValue(request, "licensePlate");
                String brand = getParameterValue(request, "brand");
                String model = getParameterValue(request, "model");
                String vehicleType = getParameterValue(request, "vehicleType");
                String color = getParameterValue(request, "color");

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

                    // Kiểm tra xem biển số này đã tồn tại dạng deactive chưa
                    Vehicle existingDeactive = vehicleDAO.findDeactivatedByLicensePlate(licensePlate,
                            customer.getCustomerID());

                    boolean isSuccess;
                    String successMsg;
                    if (existingDeactive != null) {
                        // Xe đã bị xóa mềm → reactivate và cập nhật thông tin mới
                        vehicle.setVehicleID(existingDeactive.getVehicleID());
                        isSuccess = vehicleDAO.reactivateVehicle(vehicle);
                        successMsg = "Vehicle restored and updated successfully!";
                    } else {
                        // Xe hoàn toàn mới → insert bình thường
                        isSuccess = vehicleDAO.insertVehicle(vehicle);
                        successMsg = "Vehicle added successfully!";
                    }

                    if (isSuccess) {
                        session.setAttribute("SUCCESS_MSG", successMsg);
                    } else {
                        session.setAttribute("ERROR_MSG", "Failed to add vehicle.");
                    }
                } else if ("edit".equals(action)) {
                    int vehicleID = Integer.parseInt(getParameterValue(request, "vehicleID"));

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
                        String oldImage = getParameterValue(request, "oldImage");
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

    private String getParameterValue(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        if (value != null) {
            return value;
        }
        try {
            Part part = request.getPart(paramName);
            if (part != null) {
                java.util.Scanner scanner = new java.util.Scanner(part.getInputStream(), "UTF-8");
                return scanner.hasNext() ? scanner.useDelimiter("\\A").next() : null;
            }
        } catch (Exception e) {
            // Ignore
        }
        return null;
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
