module thermal_sensor_calibration (
    input [11:0] raw_reading,
    input [3:0] calibration_factor,
    output reg [11:0] calibrated_temperature
);
    always @(*) begin
        calibrated_temperature = (raw_reading * calibration_factor) >> 4; // Division by 16
    end
endmodule