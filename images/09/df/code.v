module thermal_sensor_calibration (
    input [3:0] raw_data,
    output [3:0] calibrated_data
);
    wire [4:0] temp_data; // 5 bits to accommodate overflow

    assign temp_data = raw_data + 4'b0011; // Add offset of 3
    assign calibrated_data = (temp_data > 4'b1111) ? 4'b1111 : temp_data[3:0]; // Cap at 15

endmodule