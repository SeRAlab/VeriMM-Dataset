module thermal_sensor_calibration (
    input clk,
    input [7:0] temperature_reading,
    input [7:0] calibration_offset,
    output reg [7:0] calibrated_temperature
);
    always @(posedge clk) begin
        calibrated_temperature <= temperature_reading + calibration_offset;
    end
endmodule