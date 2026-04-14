module mux_8to1 (A, B, C, D, E, F, G, H, SEL, Y);
input A;
input B;
input C;
input D;
input E;
input F;
input G;
input H;
input [2:0] SEL;
output Y;

assign Y = (SEL == 3'b000) ? A :
           (SEL == 3'b001) ? B :
           (SEL == 3'b010) ? C :
           (SEL == 3'b011) ? D :
           (SEL == 3'b100) ? E :
           (SEL == 3'b101) ? F :
           (SEL == 3'b110) ? G : H;

endmodule