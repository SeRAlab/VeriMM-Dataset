module top_module(
    input [3:0] A, B, C, D,
    input [1:0] S,
    output reg Z
);always @(*) begin
    case (S)
        2'b00: Z = A;
        2'b01: Z = B;
        2'b10: Z = C;
        2'b11: Z = D;
    endcase
end

endmodule