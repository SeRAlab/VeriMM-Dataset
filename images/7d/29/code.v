module mux_16to1 (D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15, S, Y);
input D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15;
input [3:0] S;
output reg Y;

always @(*) begin
    case (S)
        4'b0000: Y = D0;
        4'b0001: Y = D1;
        4'b0010: Y = D2;
        4'b0011: Y = D3;
        4'b0100: Y = D4;
        4'b0101: Y = D5;
        4'b0110: Y = D6;
        4'b0111: Y = D7;
        4'b1000: Y = D8;
        4'b1001: Y = D9;
        4'b1010: Y = D10;
        4'b1011: Y = D11;
        4'b1100: Y = D12;
        4'b1101: Y = D13;
        4'b1110: Y = D14;
        4'b1111: Y = D15;
        default: Y = D0;
    endcase
end

endmodule