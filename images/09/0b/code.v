module thermal_sensor_calibration (
    input [9:0] temp_input,
    input [9:0] offset,
    output [9:0] calibrated_temp
);
    assign calibrated_temp = temp_input + offset;
endmodule