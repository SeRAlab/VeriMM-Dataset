module huffman_encoder (
    input [7:0] in_char,
    output reg [7:0] out_code
);
    always @(*) begin
        case (in_char)
            8'd65: out_code = 8'b111;   // A
            8'd66: out_code = 8'b110;   // B
            8'd67: out_code = 8'b101;   // C
            8'd68: out_code = 8'b100;   // D
            8'd69: out_code = 8'b011;   // E
            8'd70: out_code = 8'b0;     // F
            default: out_code = 8'bxxxx; // undefined input
        endcase
    end
endmodule