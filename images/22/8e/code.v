module thermal_sensor_calibration(
    input clk,
    input reset,
    input [7:0] raw_temp,
    input [7:0] calibration_factor,
    output reg [7:0] calibrated_temp
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            calibrated_temp <= 8'b0;
        end else begin
            calibrated_temp <= (raw_temp + calibration_factor) % 256;
        end
    end
    
endmodule