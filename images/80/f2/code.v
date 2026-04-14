module mux_4to1_4bit (D0, D1, D2, D3, S, Y);
input [3:0] D0, D1, D2, D3;
input [1:0] S;
output reg [3:0] Y;

always @(*) begin
    case (S)
        2'b00: Y = D0;
        2'b01: Y = D1;
        2'b10: Y = D2;
        2'b11: Y = D3;
        default: Y = D0;
    endcase
end

endmodule