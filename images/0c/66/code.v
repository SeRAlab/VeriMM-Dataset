module thermal_sensor_calibration(
    input clk,
    input reset,
    input [15:0] raw_temp,
    input [15:0] calibration_factor,
    input calibrate,
    output reg [31:0] calibrated_temp
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            calibrated_temp <= 32'd0;
        end else if (calibrate) begin
            calibrated_temp <= raw_temp * calibration_factor;
        end
    end
endmodule