module thermal_sensor_calibration (
    input wire clk,
    input wire enable,
    input wire [15:0] raw_temp,        // Raw temperature input
    input wire [15:0] calibration_factor, // Calibration factor input
    output reg [15:0] calibrated_temp   // Calibrated temperature output
);
    always @(posedge clk) begin
        if (enable) begin
            calibrated_temp <= raw_temp + calibration_factor; // Simple calibration
        end
    end
endmodule