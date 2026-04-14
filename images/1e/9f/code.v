module fan_speed_control(
    input wire clk,
    input wire rst,
    input wire [2:0] temperature,
    output reg [1:0] fan_speed
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        fan_speed <= 2'b00; // Fan off on reset
    end else begin
        case (temperature)
            3'b000, 3'b001, 3'b010: fan_speed <= 2'b00; // Off
            3'b011, 3'b100, 3'b101: fan_speed <= 2'b01; // Low
            default: fan_speed <= 2'b11; // High
        endcase
    end
end

endmodule