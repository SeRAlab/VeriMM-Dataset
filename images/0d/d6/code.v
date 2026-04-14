module thermal_sensor_calibration (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [7:0] raw_temp,
    input wire [7:0] calibration_factor,
    output reg [15:0] calibrated_temp
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            calibrated_temp <= 16'b0;
        end else if (enable) begin
            calibrated_temp <= raw_temp * calibration_factor;
        end
    end
endmodule