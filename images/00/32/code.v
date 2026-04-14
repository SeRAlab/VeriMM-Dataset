module temperature_sensor(input [4:0] temp_in, output reg [2:0] temp_range);

    always @(*) begin
        case (temp_in)
            5'b00000: temp_range = 3'b000; // 0°C
            5'b00001: temp_range = 3'b000; // 1°C
            5'b00010: temp_range = 3'b000; // 2°C
            5'b00011: temp_range = 3'b000; // 3°C
            5'b00100: temp_range = 3'b000; // 4°C
            5'b00101: temp_range = 3'b000; // 5°C
            5'b00110: temp_range = 3'b000; // 6°C
            5'b00111: temp_range = 3'b000; // 7°C
            5'b01000: temp_range = 3'b000; // 8°C
            5'b01001: temp_range = 3'b000; // 9°C
            5'b01010: temp_range = 3'b001; // 10°C
            5'b01011: temp_range = 3'b001; // 11°C
            5'b01100: temp_range = 3'b001; // 12°C
            5'b01101: temp_range = 3'b001; // 13°C
            5'b01110: temp_range = 3'b001; // 14°C
            5'b01111: temp_range = 3'b001; // 15°C
            5'b10000: temp_range = 3'b001; // 16°C
            5'b10001: temp_range = 3'b001; // 17°C
            5'b10010: temp_range = 3'b001; // 18°C
            5'b10011: temp_range = 3'b001; // 19°C
            5'b10100: temp_range = 3'b010; // 20°C
            5'b10101: temp_range = 3'b010; // 21°C
            5'b10110: temp_range = 3'b010; // 22°C
            5'b10111: temp_range = 3'b010; // 23°C
            5'b11000: temp_range = 3'b010; // 24°C
            5'b11001: temp_range = 3'b010; // 25°C
            5'b11010: temp_range = 3'b010; // 26°C
            5'b11011: temp_range = 3'b010; // 27°C
            5'b11100: temp_range = 3'b010; // 28°C
            5'b11101: temp_range = 3'b010; // 29°C
            5'b11110: temp_range = 3'b011; // 30°C
            5'b11111: temp_range = 3'b011; // 31°C
            default: temp_range = 3'b100; // default case
        endcase

        if (temp_in >= 5'b11000) // 40°C
            temp_range = 3'b100; // 40°C to 49°C
        if (temp_in >= 5'b11001) // 41°C to 49°C
            temp_range = 3'b101; // 50°C and above
    end
endmodule