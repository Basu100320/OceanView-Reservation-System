package util;

public class RoomFactory {
    public static double getDefaultPrice(String type) {
        switch (type) {
            case "Single": return 5000.00;
            case "Double": return 8500.00;
            case "Luxury": return 15000.00;
            case "Suite": return 20000.00;
            default: return 0.0;
        }
    }
}