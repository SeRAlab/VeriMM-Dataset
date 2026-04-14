module huffman_encoder(
    input [1:0] symbol,
    output reg [1:0] code
);
    always @(*) begin
        case (symbol)
            2'b00: code = 2'b00; // A
            2'b01: code = 2'b01; // B
            2'b10: code = 2'b10; // C
            default: code = 2'bxx; // Undefined
        endcase
    end
endmodule