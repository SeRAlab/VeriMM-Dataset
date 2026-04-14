module fan_speed_control(
    input clk,
    input rst,
    input [2:0] temperature,
    output reg [1:0] fan_speed // 00: OFF, 01: LOW, 10: MEDIUM, 11: HIGH
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fan_speed <= 2'b00; // Default to OFF
        end else begin
            case (temperature)
                3'b000: fan_speed <= 2'b00; // OFF
                3'b001: fan_speed <= 2'b01; // LOW
                3'b010, 3'b011: fan_speed <= 2'b10; // MEDIUM
                3'b100, 3'b101, 3'b110, 3'b111: fan_speed <= 2'b11; // HIGH
                default: fan_speed <= 2'b00; // Default to OFF
            endcase
        end
    end
endmodule