package controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ImageServlet", urlPatterns = { "/uploads/* " })
public class ImageServlet extends HttpServlet {

    // Thư mục cố định lưu ảnh bên ngoài Tomcat (Cùng thư mục lưu trong
    //
    // RegisterController)
    private final String UPLOAD_DIR = "D:" + File.separator + "auto_wash_uploads";

    @Override
    protected void doGet(HttpServletRequest reques

        
        // Lấy tên file từ URL (ví dụ: URL là /uploads/123.jpg thì lấy ra 123.jpg)
        String fileName = request.getPathInfo();
        if (fileName == null || fileName.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
         

        
        // Bỏ dấu gạch chéo '/' đầu tiên

        
        File file = new File(UPLOAD_DIR, fileName);
        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
         

        
        // Xác định loại nội dung (MIME type)
        String mimeType = getServletContext().getMimeType(file.getName());
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }
        response.setContentType(mimeType);

        
        // Đọc file từ ổ đĩa và gửi qua response cho thẻ <im
                FileInputStream in = new FileInputStream(file);

            
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
