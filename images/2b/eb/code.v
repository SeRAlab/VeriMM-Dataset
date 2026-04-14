module thermal_sensor_calibration (
    input wire clk,
    input wire [7:0] raw_temp,      // 8-bit raw temperature reading
    input wire [7:0] offset,        // 8-bit calibration offset
    output reg [7:0] calibrated_temp // 8-bit calibrated temperature output
);
    
    always @(posedge clk) begin
        calibrated_temp <= raw_temp + offset; // Calibrate the temperature
    end

endmodule