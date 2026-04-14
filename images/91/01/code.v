module top_module(
    input [3:0] HEXnumber,
    output reg [7:0] Segments
);always @ (HEXnumber)
    case (HEXnumber)
        4'b0000: Segments <= 8'b11000000;
        4'b0001: Segments <= 8'b11111001;
        4'b0010: Segments <= 8'b10100100;
        4'b0011: Segments <= 8'b10110000;
        4'b0100: Segments <= 8'b10011001;
        4'b0101: Segments <= 8'b10010010;
        4'b0110: Segments <= 8'b10000010;
        4'b0111: Segments <= 8'b11111000;
        4'b1000: Segments <= 8'b10000000;
        4'b1001: Segments <= 8'b10010000;
        4'b1010: Segments <= 8'b10001000;
        4'b1011: Segments <= 8'b10000011;
        4'b1100: Segments <= 8'b11000110;
        4'b1101: Segments <= 8'b10100001;
        4'b1110: Segments <= 8'b10000110;
        4'b1111: Segments <= 8'b10001110;
        default: Segments <= 8'b00000000;
    endcase

endmodule