module thermal_sensor_calibration (
    input [4:0] raw_temp,
    output [4:0] calibrated_temp
);
    assign calibrated_temp = raw_temp + 5'd3;
endmodule