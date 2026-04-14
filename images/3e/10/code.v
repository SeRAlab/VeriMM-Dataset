module thermal_sensor_calibration (
    input [7:0] raw_temperature,
    input [7:0] calibration_offset,
    output [7:0] calibrated_temperature
);
    assign calibrated_temperature = (raw_temperature + calibration_offset > 8'hFF) ? 8'hFF : (raw_temperature + calibration_offset);
endmodule