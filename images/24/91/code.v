module thermal_sensor_calibration (
    input wire clk,
    input wire reset,
    input wire [9:0] raw_temperature,
    output reg [9:0] calibrated_temperature
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            calibrated_temperature <= 10'd0;
        end else begin
            calibrated_temperature <= raw_temperature + 10'd5; // Add offset of 5
        end
    end
endmodule