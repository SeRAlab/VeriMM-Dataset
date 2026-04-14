module thermal_sensor_calibration(
    input clk,
    input rst,
    input [15:0] raw_temp,
    input [7:0] calibration_factor,
    output reg [15:0] calibrated_temp
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        calibrated_temp <= 16'h0000;
    end else begin
        calibrated_temp <= raw_temp + (raw_temp * calibration_factor) >> 8; // Simple linear calibration
    end
end

endmodule