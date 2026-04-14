module binary_to_7segment(
    input [2:0] in,
    output reg [6:0] out);

always @* begin
    case (in)
        3'b000: out = 7'b0111111; // 0
        3'b001: out = 7'b0000110; // 1
        3'b010: out = 7'b1011011; // 2
        3'b011: out = 7'b1001111; // 3
        3'b100: out = 7'b1100110; // 4
        3'b101: out = 7'b1101101; // 5
        3'b110: out = 7'b1111101; // 6
        3'b111: out = 7'b0000111; // 7
        default: out = 7'b0000000; // Blank
    endcase
end

endmodule