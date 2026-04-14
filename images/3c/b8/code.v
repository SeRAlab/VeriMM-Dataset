module thermal_sensor_calibration (
    input [7:0] temp_reading, // 8-bit temperature reading
    output [7:0] calibrated_temp // 8-bit calibrated temperature
);
    wire [8:0] temp_with_offset; // 9-bit wire to hold the sum
    assign temp_with_offset = temp_reading + 8'd5; // Add the calibration offset
    assign calibrated_temp = (temp_with_offset > 8'd255) ? 8'd255 : temp_with_offset[7:0]; // Saturate if exceeds 255
endmodule