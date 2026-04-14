module fan_speed_control (
    input [3:0] temperature,
    input reset,
    input clk,
    output reg [1:0] fan_speed // 00: Low, 01: Medium, 10: High
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fan_speed <= 2'b00; // Low speed
        end else begin
            case (temperature)
                4'b0000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101: fan_speed <= 2'b00; // Low
                4'b0110, 4'b0111, 4'b1000, 4'b1001, 4'b1010: fan_speed <= 2'b01; // Medium
                4'b1011, 4'b1100, 4'b1101, 4'b1110, 4'b1111: fan_speed <= 2'b10; // High
                default: fan_speed <= 2'b00; // Default to Low
            endcase
        end
    end
endmodule