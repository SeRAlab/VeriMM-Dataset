module thermal_sensor_calibration (
    input wire clk,
    input wire rst,
    input wire [9:0] raw_sensor_value,
    input wire [3:0] calibration_offset,
    output reg [9:0] calibrated_value
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        calibrated_value <= 10'b0;
    end else begin
        calibrated_value <= raw_sensor_value + {6'b0, calibration_offset}; // Aligning 4-bit offset to 10-bit
    end
end

endmodule