package dto;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class Booking {

    private int bookingID;
    private int customerID;
    private int vehicleID;
    private String serviceType;
    private BigDecimal price;
    private String vehiclePlateSnapshot;
    private String customerNameSnapshot;
    private Date scheduledDate;
    private Time scheduledTime;
    private Timestamp createdAt;
    private String status;
    private int serviceID;

    public Booking() {
    }

    public Booking(int bookingID, int customerID, int vehicleID, String serviceType, BigDecimal price,
            String vehiclePlateSnapshot, String customerNameSnapshot, Date scheduledDate, Time scheduledTime,
            Timestamp createdAt, String status, int serviceID) {
        this.bookingID = bookingID;
        this.customerID = customerID;
        this.vehicleID = vehicleID;

        this.serviceType = serviceType;
        this.price = price;
        this.vehiclePlateSnapshot = vehiclePlateSnapshot;
        this.customerNameSnapshot = customerNameSnapshot;
        this.scheduledDate = scheduledDate;
        this.scheduledTime = scheduledTime;
        this.createdAt = createdAt;
        this.status = status;
        this.serviceID = serviceID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public int getVehicleID() {
        return vehicleID;
    }

    public void setVehicleID(int vehicleID) {
        this.vehicleID = vehicleID;
    }

    public int getServiceID() {
        return serviceID;
    }

    public void setServiceID(int serviceID) {
        this.serviceID = serviceID;
    }

    public String getServiceType() {
        return serviceType;
    }

    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getVehiclePlateSnapshot() {
        return vehiclePlateSnapshot;
    }

    public void setVehiclePlateSnapshot(String vehiclePlateSnapshot) {
        this.vehiclePlateSnapshot = vehiclePlateSnapshot;
    }

    public String getCustomerNameSnapshot() {
        return customerNameSnapshot;
    }

    public void setCustomerNameSnapshot(String customerNameSnapshot) {
        this.customerNameSnapshot = customerNameSnapshot;
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

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Booking{"
                + "bookingID=" + bookingID
                + ", customerID=" + customerID
                + ", vehicleID=" + vehicleID
                + ", serviceID=" + serviceID
                + ", serviceType='" + serviceType + '\''
                + ", price=" + price
                + ", vehiclePlateSnapshot='" + vehiclePlateSnapshot + '\''
                + ", customerNameSnapshot='" + customerNameSnapshot + '\''
                + ", scheduledDate=" + scheduledDate
                + ", scheduledTime=" + scheduledTime
                + ", createdAt=" + createdAt
                + ", status='" + status + '\''
                + '}';
    }
}
