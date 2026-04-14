module thermal_sensor_calibration (
    input wire [9:0] temperature_input,
    input wire [3:0] calibration_factor,
    output reg [9:0] calibrated_temperature
);
    
    always @(temperature_input, calibration_factor) begin
        calibrated_temperature = temperature_input + calibration_factor;
    end

endmodule