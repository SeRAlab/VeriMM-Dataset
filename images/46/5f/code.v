module binary_to_bcd(
    input [3:0] binary_in,
    output reg [7:0] bcd_out
);

always @(*) begin
    case (binary_in)
        4'b0000: bcd_out = 8'b00000000; // 0
        4'b0001: bcd_out = 8'b00000001; // 1
        4'b0010: bcd_out = 8'b00000010; // 2
        4'b0011: bcd_out = 8'b00000011; // 3
        4'b0100: bcd_out = 8'b00000100; // 4
        4'b0101: bcd_out = 8'b00000101; // 5
        4'b0110: bcd_out = 8'b00000110; // 6
        4'b0111: bcd_out = 8'b00000111; // 7
        4'b1000: bcd_out = 8'b00001000; // 8
        4'b1001: bcd_out = 8'b00001001; // 9
        4'b1010: bcd_out = 8'b00010000; // 10
        4'b1011: bcd_out = 8'b00010001; // 11
        4'b1100: bcd_out = 8'b00010010; // 12
        4'b1101: bcd_out = 8'b00010011; // 13
        4'b1110: bcd_out = 8'b00010100; // 14
        4'b1111: bcd_out = 8'b00010101; // 15
        default: bcd_out = 8'b00000000; // Default case
    endcase
end

endmodule