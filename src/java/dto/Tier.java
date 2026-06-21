package dto;

import java.math.BigDecimal;

public class Tier {
    private int tierID;
    private String tierName;
    private int minWashes;
    private BigDecimal minSpend;
    private int bookingWindow;

    public Tier() {
    }

    public Tier(int tierID, String tierName, int minWashes, BigDecimal minSpend, int bookingWindow) {
        this.tierID = tierID;
        this.tierName = tierName;
        this.minWashes = minWashes;
        this.minSpend = minSpend;
        this.bookingWindow = bookingWindow;
    }

    public int getTierID() {
        return tierID;
    }

    public void setTierID(int tierID) {
        this.tierID = tierID;
    }

    public String getTierName() {
        return tierName;
    }

    public void setTierName(String tierName) {
        this.tierName = tierName;
    }

    public int getMinWashes() {
        return minWashes;
    }

    public void setMinWashes(int minWashes) {
        this.minWashes = minWashes;
    }

    public BigDecimal getMinSpend() {
        return minSpend;
    }

    public void setMinSpend(BigDecimal minSpend) {
        this.minSpend = minSpend;
    }

    public int getBookingWindow() {
        return bookingWindow;
    }

    public void setBookingWindow(int bookingWindow) {
        this.bookingWindow = bookingWindow;
    }

    @Override
    public String toString() {
        return "Tier{" +
                "tierID=" + tierID +
                ", tierName='" + tierName + '\'' +
                ", minWashes=" + minWashes +
                ", minSpend=" + minSpend +
                ", bookingWindow=" + bookingWindow +
                '}';
    }
}
