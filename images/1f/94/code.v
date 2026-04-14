module ThermalSensorCalibrator(
    input clk,
    input reset,
    input [15:0] raw_temperature,
    input [15:0] calibration_factor,
    output reg [15:0] calibrated_temperature
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            calibrated_temperature <= 16'b0;
        end else begin
            calibrated_temperature <= raw_temperature + calibration_factor;
        end
    end
endmodule