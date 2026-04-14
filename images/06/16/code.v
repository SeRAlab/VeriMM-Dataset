module fan_speed_controller (
    input wire clk,
    input wire rst,
    input wire [7:0] temperature,
    output reg [1:0] fan_speed // 00: off, 01: low, 10: medium, 11: high
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fan_speed <= 2'b00; // Off
        end else begin
            if (temperature < 20) begin
                fan_speed <= 2'b00; // Off
            end else if (temperature < 25) begin
                fan_speed <= 2'b01; // Low
            end else if (temperature < 30) begin
                fan_speed <= 2'b10; // Medium
            end else begin
                fan_speed <= 2'b11; // High
            end
        end
    end
endmodule