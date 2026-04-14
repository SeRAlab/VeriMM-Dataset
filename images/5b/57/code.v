module mux_4to1(SEL, A, B, C, D, Y);
input [1:0] SEL;
input A, B, C, D;
output reg Y;

always @(SEL or A or B or C or D) begin
    case (SEL)
        2'b00: Y = A;
        2'b01: Y = B;
        2'b10: Y = C;
        2'b11: Y = D;
        default: Y = 1'b0;
    endcase
end

endmodule