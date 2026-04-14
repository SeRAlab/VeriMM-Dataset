module fan_speed_control (
    input [3:0] temperature,
    input [1:0] control,
    output reg [2:0] fan_speed
);

    always @(temperature or control) begin
        case (control)
            2'b00: fan_speed = 3'b000; // Fan off
            2'b01: begin // Control by temperature
                if (temperature < 4'd50)
                    fan_speed = 3'b000; // Off
                else if (temperature < 4'd70)
                    fan_speed = 3'b001; // Low
                else if (temperature < 4'd90)
                    fan_speed = 3'b010; // Medium
                else
                    fan_speed = 3'b011; // High
            end
            2'b10: fan_speed = 3'b010; // Medium speed
            2'b11: fan_speed = 3'b010; // Medium speed
            default: fan_speed = 3'b000; // Default to off
        endcase
    end
endmodule