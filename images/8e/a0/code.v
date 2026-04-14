module mux_8to1 (D0, D1, D2, D3, D4, D5, D6, D7, S, Y);
input D0, D1, D2, D3, D4, D5, D6, D7;
input [2:0] S;
output reg Y;

always @(*) begin
    case (S)
        3'b000: Y = D0;
        3'b001: Y = D1;
        3'b010: Y = D2;
        3'b011: Y = D3;
        3'b100: Y = D4;
        3'b101: Y = D5;
        3'b110: Y = D6;
        3'b111: Y = D7;
        default: Y = D0;
    endcase
end

endmodule