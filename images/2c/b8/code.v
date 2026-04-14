module fan_speed_control (
    input [2:0] temperature,
    output reg [1:0] fan_speed
);
    always @(temperature) begin
        case (temperature)
            3'b000, 3'b001, 3'b010: fan_speed = 2'b00; // off
            3'b011, 3'b100: fan_speed = 2'b01; // low
            3'b101, 3'b110: fan_speed = 2'b10; // medium
            3'b111: fan_speed = 2'b11; // high
            default: fan_speed = 2'b00; // default to off
        endcase
    end
endmodule