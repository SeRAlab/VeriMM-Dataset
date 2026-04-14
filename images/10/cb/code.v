module fan_speed_control(
    input [3:0] temperature,
    input clk,
    input rst,
    output reg [1:0] speed
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            speed <= 2'b00; // Off
        end else begin
            case (temperature)
                4'b0000, 4'b0001, 4'b0010, 4'b0011, 4'b0100: speed <= 2'b00; // Off
                4'b0101, 4'b0110, 4'b0111, 4'b1000, 4'b1001: speed <= 2'b01; // Low
                4'b1010, 4'b1011, 4'b1100, 4'b1101: speed <= 2'b10; // Medium
                4'b1110, 4'b1111: speed <= 2'b11; // High
                default: speed <= 2'b00; // Off
            endcase
        end
    end
endmodule