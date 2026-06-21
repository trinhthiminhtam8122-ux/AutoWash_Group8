package dto;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class AdminBookingDTO {

    private int bookingID;
    private String customerName;
    private String phone;
    private String licensePlate;
    private String vehicleModel;
    private String serviceName;
    private Date scheduledDate;
    private Time scheduledTime;
    private String status;
    private Integer stationNo;
    private Timestamp checkInTime;
    private Timestamp expectedEndTime;
    private Timestamp checkOutTime;
    private int remainingSeconds;
    private boolean needCheckout;

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public String getVehicleModel() {
        return vehicleModel;
    }

    public void setVehicleModel(String vehicleModel) {
        this.vehicleModel = vehicleModel;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public Date getScheduledDate() {
        return scheduledDate;
    }

    public void setScheduledDate(Date scheduledDate) {
        this.scheduledDate = scheduledDate;
    }

    public Time getScheduledTime() {
        return scheduledTime;
    }

    public void setScheduledTime(Time scheduledTime) {
        this.scheduledTime = scheduledTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getStationNo() {
        return stationNo;
    }

    public void setStationNo(Integer stationNo) {
        this.stationNo = stationNo;
    }

    public Timestamp getCheckInTime() {
        return checkInTime;
    }

    public void setCheckInTime(Timestamp checkInTime) {
        this.checkInTime = checkInTime;
    }

    public Timestamp getExpectedEndTime() {
        return expectedEndTime;
    }

    public void setExpectedEndTime(Timestamp expectedEndTime) {
        this.expectedEndTime = expectedEndTime;
    }

    public Timestamp getCheckOutTime() {
        return checkOutTime;
    }

    public void setCheckOutTime(Timestamp checkOutTime) {
        this.checkOutTime = checkOutTime;
    }

    public int getRemainingSeconds() {
        return remainingSeconds;
    }

    public void setRemainingSeconds(int remainingSeconds) {
        this.remainingSeconds = remainingSeconds;
    }

    public boolean isNeedCheckout() {
        return needCheckout;
    }

    public void setNeedCheckout(boolean needCheckout) {
        this.needCheckout = needCheckout;
    }

    public boolean isPending() {
        return "Pending".equalsIgnoreCase(status);
    }

    public boolean isWashing() {
        return "Washing".equalsIgnoreCase(status);
    }

    public boolean isCompleted() {
        return "Completed".equalsIgnoreCase(status);
    }

    public String getBookingCode() {
        String datePart = "000000";
        if (scheduledDate != null) {
            datePart = new SimpleDateFormat("yyMMdd").format(scheduledDate);
        }
        return "BK" + datePart + "-" + String.format("%03d", bookingID);
    }

    public String getStationText() {
        return stationNo == null ? "-" : "Station " + stationNo;
    }

    public String getStatusText() {
        if (needCheckout) {
            return "Need Check-out";
        }
        return status == null || status.trim().isEmpty() ? "Pending" : status;
    }

    public String getStatusClass() {
        if (needCheckout) {
            return "need-checkout";
        }
        String value = getStatusText().toLowerCase();
        return value.replace(" ", "-");
    }

    public String getTimerText() {
        if (!isWashing()) {
            return "-";
        }
        int seconds = Math.max(0, remainingSeconds);
        return String.format("%02d:%02d", seconds / 60, seconds % 60);
    }

    public String getScheduledTimeStr() {
        if (scheduledTime == null) {
            return "-";
        }
        // java.sql.Time.toString() trả về HH:mm:ss, lấy 5 ký tự đầu
        String t = scheduledTime.toString();
        return t.length() >= 5 ? t.substring(0, 5) : t;
    }
}
