module thermal_sensor_calibration (
    input [4:0] raw_temperature,
    output reg [4:0] calibrated_temperature
);
    always @(*) begin
        case (raw_temperature)
            5'b00000: calibrated_temperature = 5'b00000; // No calibration
            5'b00001: calibrated_temperature = 5'b00001; // No calibration
            5'b00010: calibrated_temperature = 5'b00010; // No calibration
            5'b00011: calibrated_temperature = 5'b00011; // No calibration
            5'b00100: calibrated_temperature = 5'b00011; // Apply offset of 1
            5'b00101: calibrated_temperature = 5'b00100; // Apply offset of 1
            5'b00110: calibrated_temperature = 5'b00101; // Apply offset of 1
            5'b00111: calibrated_temperature = 5'b00110; // Apply offset of 1
            5'b01000: calibrated_temperature = 5'b00111; // Apply offset of 2
            5'b01001: calibrated_temperature = 5'b01000; // Apply offset of 2
            5'b01010: calibrated_temperature = 5'b01001; // Apply offset of 2
            5'b01011: calibrated_temperature = 5'b01010; // Apply offset of 2
            // Additional cases can be defined based on input ranges
            default: calibrated_temperature = 5'b11111; // Error case
        endcase
    end
endmodule