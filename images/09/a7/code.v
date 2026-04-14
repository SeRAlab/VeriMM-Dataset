module fan_speed_control (
    input wire clk,
    input wire rst,
    input wire [2:0] temp,
    output reg [2:0] fan_speed
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fan_speed <= 3'b000; // Off
        end else begin
            case (temp)
                3'b000: fan_speed <= 3'b000; // Off
                3'b001: fan_speed <= 3'b001; // Low
                3'b010: fan_speed <= 3'b010; // Medium
                3'b011: fan_speed <= 3'b011; // High
                3'b100: fan_speed <= 3'b100; // Maximum
                default: fan_speed <= 3'b100; // Maximum for temp > 100
            endcase
        end
    end
endmodule