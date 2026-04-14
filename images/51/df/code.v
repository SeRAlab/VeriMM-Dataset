module mux_4to1 (A, D0, D1, D2, D3, Y);
input [1:0] A;
input D0, D1, D2, D3;
output reg Y;

always @(*) begin
    case (A)
        2'b00: Y = D0;
        2'b01: Y = D1;
        2'b10: Y = D2;
        2'b11: Y = D3;
        default: Y = 1'b0;
    endcase
end

endmodule