module thermal_sensor_calibration (
    input [4:0] sensor_reading,
    output [4:0] calibrated_value
);
    assign calibrated_value = sensor_reading + 5;
endmodule