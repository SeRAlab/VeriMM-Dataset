module top_module( A, B, C, G2A, G2B, G1,
	Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7);input A, B, C, G2A, G2B, G1;
  output Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7;

  assign { Y0,Y1,Y2,Y3,Y4,Y5,Y6,Y7 } =
    ({C,B,A} == 3'b000) & (G1 & !(G2A | G2B)) ? 8'b01111111 :
    ({C,B,A} == 3'b001) & (G1 & !(G2A | G2B)) ? 8'b10111111 :
    ({C,B,A} == 3'b010) & (G1 & !(G2A | G2B)) ? 8'b11011111 :
    ({C,B,A} == 3'b011) & (G1 & !(G2A | G2B)) ? 8'b11101111 :
    ({C,B,A} == 3'b100) & (G1 & !(G2A | G2B)) ? 8'b11110111 :
    ({C,B,A} == 3'b101) & (G1 & !(G2A | G2B)) ? 8'b11111011 :
    ({C,B,A} == 3'b110) & (G1 & !(G2A | G2B)) ? 8'b11111101 :
    ({C,B,A} == 3'b111) & (G1 & !(G2A | G2B)) ? 8'b11111110 :
    8'b11111111;





endmodule