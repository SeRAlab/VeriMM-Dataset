module thermal_sensor_calibration(
    input [4:0] temperature,
    output [4:0] calibrated_temperature
);
    // Constant offset for calibration
    parameter OFFSET = 5'd3;  
    wire [4:0] temp_with_offset;

    // Add the OFFSET to the temperature input
    assign temp_with_offset = temperature + OFFSET;

    // Ensure the output does not exceed the maximum 5-bit value
    assign calibrated_temperature = (temp_with_offset > 5'd31) ? 5'd31 : temp_with_offset;

endmodule