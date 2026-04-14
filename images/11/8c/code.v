module fan_speed_control(
    input clk,
    input reset,
    input [2:0] temperature,
    output reg [1:0] fan_speed
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        fan_speed <= 2'b00; // Reset fan speed to 0
    end else begin
        case (temperature)
            3'b000, 3'b001: fan_speed <= 2'b00; // Speed 0
            3'b010, 3'b011, 3'b100: fan_speed <= 2'b01; // Speed 1
            3'b101, 3'b110: fan_speed <= 2'b10; // Speed 2
            3'b111: fan_speed <= 2'b11; // Speed 3
            default: fan_speed <= 2'b00; // Default to speed 0
        endcase
    end
end
endmodule