module temperature_sensor (
    input [4:0] temperature,
    input clk,
    output reg [2:0] range
);
    reg [2:0] prev_range;

    always @(posedge clk) begin
        if (temperature > 5'b111111) begin
            range <= prev_range; // stay the same if input is invalid
        end else begin
            case (temperature)
                5'b00000, 5'b00001, 5'b00010, 5'b00011, 5'b00100,
                5'b00101, 5'b00110, 5'b00111, 5'b01000, 5'b01001,
                5'b01010: range <= 3'b000; // 0-10°C
                5'b01011, 5'b01100, 5'b01101, 5'b01110, 5'b01111,
                5'b10000, 5'b10001, 5'b10010: range <= 3'b001; // 11-20°C
                5'b10011, 5'b10100, 5'b10101, 5'b10110, 5'b10111,
                5'b11000, 5'b11001, 5'b11010: range <= 3'b010; // 21-30°C
                5'b11011, 5'b11100, 5'b11101, 5'b11110, 5'b11111: range <= 3'b011; // 31-40°C
                5'b100000, 5'b100001, 5'b100010, 5'b100011, 5'b100100: range <= 3'b100; // 41-50°C
                default: range <= 3'b101; // over 50°C
            endcase
            prev_range <= range; // store for invalid input case
        end
    end
endmodule