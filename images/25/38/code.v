module fan_speed_control (
    input clk,
    input reset,
    input [7:0] temperature, // 8-bit temperature input
    output reg [1:0] fan_speed // 2-bit fan speed output: 00 = off, 01 = low, 10 = medium, 11 = high
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fan_speed <= 2'b00; // off state
        end else begin
            if (temperature < 20) begin
                fan_speed <= 2'b01; // low speed
            end else if (temperature < 30) begin
                fan_speed <= 2'b10; // medium speed
            end else begin
                fan_speed <= 2'b11; // high speed
            end
        end
    end
endmodule