module binary_to_bcd(
    input wire [3:0] bin,
    output reg [7:0] bcd
    );

always @(*) begin
    case (bin)
        4'b0000: bcd = 8'b00000000;
        4'b0001: bcd = 8'b00000001;
        4'b0010: bcd = 8'b00000010;
        4'b0011: bcd = 8'b00000011;
        4'b0100: bcd = 8'b00000100;
        4'b0101: bcd = 8'b00000101;
        4'b0110: bcd = 8'b00000110;
        4'b0111: bcd = 8'b00000111;
        4'b1000: bcd = 8'b00001000;
        4'b1001: bcd = 8'b00001001;
        4'b1010: bcd = 8'b00010000;
        4'b1011: bcd = 8'b00010001;
        4'b1100: bcd = 8'b00010010;
        4'b1101: bcd = 8'b00010011;
        4'b1110: bcd = 8'b00010100;
        4'b1111: bcd = 8'b00010101;
        default: bcd = 8'b00000000;
    endcase
end

endmodule