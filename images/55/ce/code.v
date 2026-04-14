module multiplexer_4to1(S, D0, D1, D2, D3, Y);
input [1:0] S;
input D0, D1, D2, D3;
output reg Y;

always @(S or D0 or D1 or D2 or D3) begin
    case (S)
        2'b00: Y = D0;
        2'b01: Y = D1;
        2'b10: Y = D2;
        2'b11: Y = D3;
        default: Y = 1'b0;
    endcase
end

endmodule