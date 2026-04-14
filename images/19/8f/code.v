module thermal_sensor_calibration(
    input clk,
    input reset,
    input [15:0] raw_temp,
    input [15:0] calibration_coeff,
    output reg [15:0] calibrated_temp
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            calibrated_temp <= 16'd0;
        end else begin
            calibrated_temp <= raw_temp + calibration_coeff; // Calibration adjustment
        end
    end
endmodule