module thermal_sensor_calibration(
    input wire clk,
    input wire rst,
    input wire [9:0] raw_temp,
    input wire [3:0] cal_factor,
    output reg [9:0] calibrated_temp
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            calibrated_temp <= 10'b0;
        end else begin
            calibrated_temp <= raw_temp + (raw_temp * cal_factor) >> 4; // (raw_temp * cal_factor / 16)
        end
    end
endmodule