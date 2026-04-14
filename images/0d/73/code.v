module fan_speed_controller(
    input wire clk,
    input wire rst,
    input wire [3:0] temp,
    output reg [1:0] fan_speed
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fan_speed <= 2'b00; // Default to low speed
        end else begin
            case (temp)
                4'b0000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101: fan_speed <= 2'b00; // Low speed
                4'b0110, 4'b0111, 4'b1000, 4'b1001, 4'b1010: fan_speed <= 2'b01; // Medium speed
                4'b1011, 4'b1100, 4'b1101, 4'b1110, 4'b1111: fan_speed <= 2'b10; // High speed
                default: fan_speed <= 2'b00; // Default to low speed
            endcase
        end
    end
endmodule