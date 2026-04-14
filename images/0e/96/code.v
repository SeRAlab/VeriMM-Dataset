module fan_speed_control (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [1:0] temp,
    output reg [1:0] fan_speed
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fan_speed <= 2'b00; // Low speed on reset
        end else if (enable) begin
            case (temp)
                2'b00: fan_speed <= 2'b00; // 0°C -> Low speed
                2'b01: fan_speed <= 2'b01; // 10°C -> Medium speed
                2'b10: fan_speed <= 2'b10; // 20°C -> High speed
                2'b11: fan_speed <= 2'b10; // 30°C -> High speed
                default: fan_speed <= 2'b00; // Default to low speed
            endcase
        end
    end
endmodule