module fan_speed_control (
    input wire clk,
    input wire [1:0] temperature,
    output reg [1:0] fan_speed
);

    always @(posedge clk) begin
        case (temperature)
            2'b00: fan_speed <= 2'b00; // Low temperature -> Fan Off
            2'b01: fan_speed <= 2'b01; // Medium temperature -> Fan Low
            2'b10: fan_speed <= 2'b10; // High temperature -> Fan Medium
            2'b11: fan_speed <= 2'b11; // Very High temperature -> Fan High
            default: fan_speed <= 2'b00; // Default case for safety
        endcase
    end
endmodule