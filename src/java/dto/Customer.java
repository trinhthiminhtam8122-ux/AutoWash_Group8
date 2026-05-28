package dto;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Customer {
    private int customerID;
    private int accountID;
    private String fullName;
    private String phone;
    private int tierID;
    private int totalWashes;
    private BigDecimal lifetimeSpend;
    private int currentPoints;
    private String avatarUrl;
    private Timestamp createdAt;

    public Customer() {
    }

    public Customer(int customerID, int accountID, String fullName, String phone, int tierID, int totalWashes, BigDecimal lifetimeSpend, int currentPoints, String avatarUrl, Timestamp createdAt) {
        this.customerID = customerID;
        this.accountID = accountID;
        this.fullName = fullName;
        this.phone = phone;
        this.tierID = tierID;
        this.totalWashes = totalWashes;
        this.lifetimeSpend = lifetimeSpend;
        this.currentPoints = currentPoints;
        this.avatarUrl = avatarUrl;
        this.createdAt = createdAt;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
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

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public int getTierID() {
        return tierID;
    }

    public void setTierID(int tierID) {
        this.tierID = tierID;
    }

    public int getTotalWashes() {
        return totalWashes;
    }

    public void setTotalWashes(int totalWashes) {
        this.totalWashes = totalWashes;
    }

    public BigDecimal getLifetimeSpend() {
        return lifetimeSpend;
    }

    public void setLifetimeSpend(BigDecimal lifetimeSpend) {
        this.lifetimeSpend = lifetimeSpend;
    }

    public int getCurrentPoints() {
        return currentPoints;
    }

    public void setCurrentPoints(int currentPoints) {
        this.currentPoints = currentPoints;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Customer{" +
                "customerID=" + customerID +
                ", accountID=" + accountID +
                ", fullName='" + fullName + '\'' +
                ", phone='" + phone + '\'' +
                ", tierID=" + tierID +
                ", totalWashes=" + totalWashes +
                ", lifetimeSpend=" + lifetimeSpend +
                ", currentPoints=" + currentPoints +
                ", avatarUrl='" + avatarUrl + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
