module temperature_sensor_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] temperature,
    input wire [7:0] threshold,
    output reg alarm
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        alarm <= 0;
    end else if (temperature > threshold) begin
        alarm <= 1;
    end else begin
        alarm <= 0;
    end
end

endmodule