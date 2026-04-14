module thermal_sensor_calibration (
    input [9:0] raw_temp,
    input [9:0] offset,
    output [9:0] calibrated_temp
);
    assign calibrated_temp = raw_temp + offset;
endmodule