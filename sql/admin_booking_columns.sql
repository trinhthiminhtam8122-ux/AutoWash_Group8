IF COL_LENGTH('Booking', 'StationNo') IS NULL
BEGIN
    ALTER TABLE Booking ADD StationNo INT NULL;
END;

IF COL_LENGTH('Booking', 'CheckInTime') IS NULL
BEGIN
    ALTER TABLE Booking ADD CheckInTime DATETIME NULL;
END;

IF COL_LENGTH('Booking', 'ExpectedEndTime') IS NULL
BEGIN
    ALTER TABLE Booking ADD ExpectedEndTime DATETIME NULL;
END;

IF COL_LENGTH('Booking', 'CheckOutTime') IS NULL
BEGIN
    ALTER TABLE Booking ADD CheckOutTime DATETIME NULL;
END;
