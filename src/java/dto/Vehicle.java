package dto;

public class Vehicle {
    private int vehicleID;
    private int customerID;
    private String licensePlate;
    private String vehicleModel;
    private String color;
    private String vehicleImageUrl;

    public Vehicle() {
    }

    public Vehicle(int vehicleID, int customerID, String licensePlate, String vehicleModel, String color, String vehicleImageUrl) {
        this.vehicleID = vehicleID;
        this.customerID = customerID;
        this.licensePlate = licensePlate;
        this.vehicleModel = vehicleModel;
        this.color = color;
        this.vehicleImageUrl = vehicleImageUrl;
    }

    public int getVehicleID() {
        return vehicleID;
    }

    public void setVehicleID(int vehicleID) {
        this.vehicleID = vehicleID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
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

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getVehicleImageUrl() {
        return vehicleImageUrl;
    }

    public void setVehicleImageUrl(String vehicleImageUrl) {
        this.vehicleImageUrl = vehicleImageUrl;
    }

    @Override
    public String toString() {
        return "Vehicle{" +
                "vehicleID=" + vehicleID +
                ", customerID=" + customerID +
                ", licensePlate='" + licensePlate + '\'' +
                ", vehicleModel='" + vehicleModel + '\'' +
                ", color='" + color + '\'' +
                ", vehicleImageUrl='" + vehicleImageUrl + '\'' +
                '}';
    }
}
