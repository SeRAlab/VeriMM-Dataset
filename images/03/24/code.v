module thermal_sensor_calibration(
    input [4:0] temp_reading,
    input [4:0] calibration_offset,
    output reg [6:0] calibrated_temperature
);
    always @(*) begin
        calibrated_temperature = {2'b00, temp_reading} + {2'b00, calibration_offset};
    end
endmodule