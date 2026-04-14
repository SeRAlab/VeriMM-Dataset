module thermal_sensor_calibrator (
    input [9:0] raw_temp,
    input [9:0] calibration_offset,
    output reg [9:0] calibrated_temp
);
    always @(*) begin
        calibrated_temp = raw_temp + calibration_offset;
        if (calibrated_temp > 10'b1111111111) // 1023
            calibrated_temp = 10'b1111111111; // clamp to 1023
    end
endmodule