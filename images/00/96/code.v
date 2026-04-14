module thermal_sensor_calibration (
    input [4:0] temp_in,
    output [4:0] temp_out
);
    assign temp_out = (temp_in + 5'd3 > 5'd31) ? 5'd31 : (temp_in + 5'd3);
endmodule