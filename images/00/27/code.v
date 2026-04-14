module thermal_sensor_calibrator(
    input [9:0] sensor_reading,
    input [9:0] correction_factor,
    output reg [9:0] calibrated_reading
);
    
    always @(*) begin
        calibrated_reading = sensor_reading + correction_factor;
        
        // Clamp the output to a maximum of 1023 (10 bits)
        if (calibrated_reading > 10'b1111111111) begin
            calibrated_reading = 10'b1111111111;
        end
    end
endmodule