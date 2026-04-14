module huffman_encoder (
    input [3:0] char,
    output reg [2:0] code
);
    always @(*) begin
        case (char)
            4'b0000: code = 3'b000;
            4'b0001: code = 3'b001;
            4'b0010: code = 3'b010;
            4'b0011: code = 3'b011;
            4'b0100: code = 3'b100;
            4'b0101: code = 3'b101;
            4'b0110: code = 3'b110;
            4'b0111: code = 3'b111;
            default: code = 3'b111; // Invalid code
        endcase
    end
endmodule