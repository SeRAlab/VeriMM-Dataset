module thermal_sensor_calibration (
    input [4:0] temp_in,
    output [4:0] temp_out
);
    assign temp_out = temp_in + 5'b00011; // Add offset of 3
endmodule