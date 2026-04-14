module thermal_sensor_calibrator(
    input [9:0] raw_temp,
    input [9:0] calibration_factor,
    output [9:0] calibrated_temp
);
    assign calibrated_temp = (raw_temp + calibration_factor > 10'd1023) ? 10'd1023 : (raw_temp + calibration_factor);
endmodule