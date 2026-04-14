module fan_speed_control (
    input clk,
    input rst,
    input [1:0] temp,
    output reg [1:0] fan_speed
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fan_speed <= 2'b00; // off
        end else begin
            case (temp)
                2'b00: fan_speed <= 2'b01; // low
                2'b01: fan_speed <= 2'b10; // medium
                2'b10: fan_speed <= 2'b11; // high
                2'b11: fan_speed <= 2'b00; // off
                default: fan_speed <= 2'b00; // default to off
            endcase
        end
    end
endmodule