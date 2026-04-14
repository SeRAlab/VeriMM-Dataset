module ThermalSensorCalibrator (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [3:0] raw_temp,
    output reg [4:0] calibrated_temp // 5 bits to accommodate shifted value
);

parameter OFFSET = 1; // Constant offset for calibration

always @(posedge clk or posedge reset) begin
    if (reset) begin
        calibrated_temp <= 5'b0; // Reset calibrated temperature
    end else if (enable) begin
        calibrated_temp <= (raw_temp << 1) + OFFSET; // Shift left and add offset
    end
end

endmodule