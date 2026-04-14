module fan_speed_control (
    input [1:0] temp_level,
    output reg fan_speed
);

    always @(temp_level) begin
        case (temp_level)
            2'b00: fan_speed = 1; // low speed
            2'b01: fan_speed = 1; // medium speed
            2'b10: fan_speed = 1; // high speed
            2'b11: fan_speed = 0; // off
            default: fan_speed = 0; // default off
        endcase
    end
endmodule