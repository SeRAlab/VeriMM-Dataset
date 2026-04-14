module linear_voltage_regulator (
    input [4:0] voltage_in,
    output reg [4:0] voltage_out
);

always @* begin
    case (voltage_in)
        5'b00000: voltage_out = 5'b00000; // 0V
        5'b00001: voltage_out = 5'b00001; // 1V
        5'b00010: voltage_out = 5'b00010; // 2V
        5'b00011: voltage_out = 5'b00011; // 3V
        5'b00100: voltage_out = 5'b00011; // 3V
        5'b00101: voltage_out = 5'b00011; // 3V
        5'b00110: voltage_out = 5'b00011; // 3V
        5'b00111: voltage_out = 5'b00100; // 4V
        5'b01000: voltage_out = 5'b00100; // 4V
        5'b01001: voltage_out = 5'b00101; // 5V
        5'b01010: voltage_out = 5'b00110; // 6V
        5'b01011: voltage_out = 5'b00110; // 6V
        5'b01100: voltage_out = 5'b00111; // 7V
        5'b01101: voltage_out = 5'b00111; // 7V
        5'b01110: voltage_out = 5'b00111; // 7V
        5'b01111: voltage_out = 5'b01000; // 8V
        5'b10000: voltage_out = 5'b01001; // 9V
        5'b10001: voltage_out = 5'b01010; // 10V
        5'b10010: voltage_out = 5'b01011; // 11V
        5'b10011: voltage_out = 5'b01100; // 12V
        5'b10100: voltage_out = 5'b01101; // 13V
        5'b10101: voltage_out = 5'b01110; // 14V
        5'b10110: voltage_out = 5'b01110; // 14V
        5'b10111: voltage_out = 5'b01111; // 15V
        5'b11000: voltage_out = 5'b10000; // 16V
        5'b11001: voltage_out = 5'b10001; // 17V
        5'b11010: voltage_out = 5'b10010; // 18V
        5'b11011: voltage_out = 5'b10010; // 18V
        5'b11100: voltage_out = 5'b10011; // 19V
        5'b11101: voltage_out = 5'b10011; // 19V
        5'b11110: voltage_out = 5'b10100; // 20V
        5'b11111: voltage_out = 5'b10101; // 21V
        default:  voltage_out = 5'b00000; // Default case
    endcase
end

endmodule