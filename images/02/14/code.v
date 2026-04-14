module fan_speed_control(
    input clk,
    input reset,
    input [7:0] temperature,
    output reg [1:0] fan_speed // 00: Off, 01: Low, 10: Medium, 11: High
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fan_speed <= 2'b00; // Off
        end else begin
            if (temperature < 20)
                fan_speed <= 2'b00; // Off
            else if (temperature >= 20 && temperature < 30)
                fan_speed <= 2'b01; // Low
            else if (temperature >= 30 && temperature < 40)
                fan_speed <= 2'b10; // Medium
            else
                fan_speed <= 2'b11; // High
        end
    end
endmodule