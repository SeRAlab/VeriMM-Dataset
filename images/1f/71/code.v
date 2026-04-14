module fan_speed_controller(
    input wire clk,
    input wire reset,
    input wire [1:0] temperature,
    output reg [1:0] fan_speed // 00: OFF, 01: LOW, 10: HIGH
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fan_speed <= 2'b00; // Initial state OFF
        end else begin
            case (temperature)
                2'b00: fan_speed <= 2'b00; // OFF
                2'b01: fan_speed <= 2'b01; // LOW
                2'b10: fan_speed <= 2'b10; // HIGH
                2'b11: fan_speed <= 2'b10; // HIGH
                default: fan_speed <= 2'b00; // Default to OFF
            endcase
        end
    end
endmodule