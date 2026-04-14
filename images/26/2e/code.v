module fan_speed_control (
    input [4:0] temperature,
    input enable,
    output reg [2:0] fan_speed
);
    always @(*) begin
        if (!enable) begin
            fan_speed = 3'b000; // Fan speed set to 0 when disabled
        end else begin
            case (temperature)
                5'b00000: fan_speed = 3'b000; // 0-15
                5'b00001: fan_speed = 3'b000; // 0-15
                5'b00010: fan_speed = 3'b000; // 0-15
                5'b00011: fan_speed = 3'b000; // 0-15
                5'b00100: fan_speed = 3'b000; // 0-15
                5'b00101: fan_speed = 3'b000; // 0-15
                5'b00110: fan_speed = 3'b000; // 0-15
                5'b00111: fan_speed = 3'b000; // 0-15
                5'b01000: fan_speed = 3'b000; // 0-15
                5'b01001: fan_speed = 3'b000; // 0-15
                5'b01010: fan_speed = 3'b000; // 0-15
                5'b01011: fan_speed = 3'b000; // 0-15
                5'b01100: fan_speed = 3'b000; // 0-15
                5'b01101: fan_speed = 3'b000; // 0-15
                5'b01110: fan_speed = 3'b000; // 0-15
                5'b01111: fan_speed = 3'b000; // 0-15
                // 16-31 range
                5'b10000: fan_speed = 3'b001; // 16-31
                5'b10001: fan_speed = 3'b001; // 16-31
                5'b10010: fan_speed = 3'b001; // 16-31
                5'b10011: fan_speed = 3'b001; // 16-31
                5'b10100: fan_speed = 3'b001; // 16-31
                5'b10101: fan_speed = 3'b001; // 16-31
                5'b10110: fan_speed = 3'b001; // 16-31
                5'b10111: fan_speed = 3'b001; // 16-31
                5'b11000: fan_speed = 3'b001; // 16-31
                5'b11001: fan_speed = 3'b001; // 16-31
                5'b11010: fan_speed = 3'b001; // 16-31
                5'b11011: fan_speed = 3'b001; // 16-31
                5'b11100: fan_speed = 3'b001; // 16-31
                5'b11101: fan_speed = 3'b001; // 16-31
                5'b11110: fan_speed = 3'b001; // 16-31
                5'b11111: fan_speed = 3'b001; // 16-31
                // 32-47 range
                // Similar for other ranges...
                default: fan_speed = 3'b000; // Default case
            endcase
        end
    end
endmodule