module thermal_sensor_calibration (
    input [4:0] raw_temp,
    output [4:0] calibrated_temp
);
    assign calibrated_temp = (raw_temp + 5'b00011) & 5'b11111; // Adding offset of 3 and masking to 5 bits
endmodule