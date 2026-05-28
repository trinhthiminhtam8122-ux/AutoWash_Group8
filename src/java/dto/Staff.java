package dto;

public class Staff {
    private int staffID;
    private int accountID;
    private String fullName;
    private String role;

    public Staff() {
    }

    public Staff(int staffID, int accountID, String fullName, String role) {
        this.staffID = staffID;
        this.accountID = accountID;
        this.fullName = fullName;
        this.role = role;
    }

    public int getStaffID() {
        return staffID;
    }

    public void setStaffID(int staffID) {
        this.staffID = staffID;
    }

    public int getAccountID() {
        return accountID;
    }

    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    @Override
    public String toString() {
        return "Staff{" +
                "staffID=" + staffID +
                ", accountID=" + accountID +
                ", fullName='" + fullName + '\'' +
                ", role='" + role + '\'' +
                '}';
    }
}
