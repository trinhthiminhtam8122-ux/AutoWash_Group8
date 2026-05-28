package dto;

public class Reward {
    private int rewardID;
    private String rewardName;
    private int pointsCost;
    private String description;

    public Reward() {
    }

    public Reward(int rewardID, String rewardName, int pointsCost, String description) {
        this.rewardID = rewardID;
        this.rewardName = rewardName;
        this.pointsCost = pointsCost;
        this.description = description;
    }

    public int getRewardID() {
        return rewardID;
    }

    public void setRewardID(int rewardID) {
        this.rewardID = rewardID;
    }

    public String getRewardName() {
        return rewardName;
    }

    public void setRewardName(String rewardName) {
        this.rewardName = rewardName;
    }

    public int getPointsCost() {
        return pointsCost;
    }

    public void setPointsCost(int pointsCost) {
        this.pointsCost = pointsCost;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "Reward{" +
                "rewardID=" + rewardID +
                ", rewardName='" + rewardName + '\'' +
                ", pointsCost=" + pointsCost +
                ", description='" + description + '\'' +
                '}';
    }
}
