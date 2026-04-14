module thermal_sensor_calibration (
    input wire clk,
    input wire reset,
    input wire [7:0] raw_temp,
    input wire [7:0] offset,
    output reg [7:0] calibrated_temp
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            calibrated_temp <= 8'b0;
        end else begin
            calibrated_temp <= raw_temp + offset;
        end
    end
endmodule