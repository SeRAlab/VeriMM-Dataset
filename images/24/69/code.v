module thermal_sensor_calibration(
    input [4:0] raw_temp,
    output [4:0] calibrated_temp
);
    // Offset for calibration
    parameter OFFSET = 5'd3;
    
    assign calibrated_temp = (raw_temp + OFFSET) % 32;
endmodule