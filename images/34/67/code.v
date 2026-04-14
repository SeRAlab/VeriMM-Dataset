module thermal_sensor_calibration(
    input wire clk,
    input wire [11:0] raw_temp,       // 12-bit raw temperature input
    input wire [11:0] calibration_factor, // 12-bit calibration factor
    input wire enable_calibration,     // Enable signal for calibration
    output reg [11:0] calibrated_temp   // 12-bit calibrated temperature output
);
    always @(posedge clk) begin
        if (enable_calibration) begin
            calibrated_temp <= raw_temp + calibration_factor; // Apply calibration
        end
    end
endmodule