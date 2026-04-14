module fan_speed_controller (
    input clk,
    input rst,
    input [7:0] temperature,
    output reg [1:0] fan_speed // 00: off, 01: low, 10: medium, 11: high
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fan_speed <= 2'b00; // off
        end else begin
            if (temperature < 20) begin
                fan_speed <= 2'b01; // low
            end else if (temperature < 30) begin
                fan_speed <= 2'b10; // medium
            end else begin
                fan_speed <= 2'b11; // high
            end
        end
    end
endmodule