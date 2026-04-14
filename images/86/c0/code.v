module binary_to_bcd_4bit(
    input wire [3:0] binary_in,
    output reg [4:0] bcd_out
    );

always @(*) begin
    case (binary_in)
        4'b0000: bcd_out = 5'b00000;
        4'b0001: bcd_out = 5'b00001;
        4'b0010: bcd_out = 5'b00010;
        4'b0011: bcd_out = 5'b00011;
        4'b0100: bcd_out = 5'b00100;
        4'b0101: bcd_out = 5'b00101;
        4'b0110: bcd_out = 5'b00110;
        4'b0111: bcd_out = 5'b00111;
        4'b1000: bcd_out = 5'b01000;
        4'b1001: bcd_out = 5'b01001;
        4'b1010: bcd_out = 5'b10000;  // Representing 10 in BCD
        4'b1011: bcd_out = 5'b10001;  // Representing 11 in BCD
        4'b1100: bcd_out = 5'b10010;  // Representing 12 in BCD
        4'b1101: bcd_out = 5'b10011;  // Representing 13 in BCD
        4'b1110: bcd_out = 5'b10100;  // Representing 14 in BCD
        4'b1111: bcd_out = 5'b10101;  // Representing 15 in BCD
        default: bcd_out = 5'b00000;
    endcase
end

endmodule