module thermal_sensor_calibration (
    input [7:0] temperature_in,
    output [7:0] temperature_out
);
    assign temperature_out = temperature_in * 12 / 10; // scaling factor of 1.2
endmodule