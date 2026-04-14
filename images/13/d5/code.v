module thermal_sensor_calibration(
    input wire clk,
    input wire reset,
    input wire [15:0] raw_temp,
    input wire [15:0] calibration_offset,
    output reg [15:0] calibrated_temp
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        calibrated_temp <= 16'b0;
    end else begin
        calibrated_temp <= raw_temp + calibration_offset;
    end
end

endmodule