module top_module(
    input [1:0] S,
    input A,
    input B,
    input C,
    input D,
    output reg Y
);always @ (S, A, B, C, D)
begin
    case (S)
        2'b00: Y = C;
        2'b01: Y = D;
        2'b10: Y = A;
        2'b11: Y = B;
    endcase
end

endmodule