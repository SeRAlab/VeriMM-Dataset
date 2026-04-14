module mux_4to1(A, B, C, D, SEL, Y);
input A, B, C, D;
input [1:0] SEL;
output Y;

assign Y = (SEL == 2'b00) ? A :
           (SEL == 2'b01) ? B :
           (SEL == 2'b10) ? C :
                            D;

endmodule