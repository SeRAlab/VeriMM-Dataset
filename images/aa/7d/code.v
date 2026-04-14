module top_module(a0,b0,c0,d0,a1,b1,c1,d1,a2,b2,c2,d2,a3,b3,c3,d3,s0,s1,y0,y1,y2,y3);input a0,b0,c0,d0;
input a1,b1,c1,d1;
input a2,b2,c2,d2;
input a3,b3,c3,d3;
input s0,s1;
output y0,y1,y2,y3;

wire wire0,wire1,wire2,wire3;
wire wire4,wire5,wire6,wire7;
wire wire8,wire9,wire10,wire11;
wire wire12,wire13,wire14,wire15;

assign wire0 = a0 & ~s0 & ~s1;
assign wire1 = b0 & ~s0 & s1;
assign wire2 = c0 & s0 & ~s1;
assign wire3 = d0 & s0 & s1;

assign wire4 = a1 & ~s0 & ~s1;
assign wire5 = b1 & ~s0 & s1;
assign wire6 = c1 & s0 & ~s1;
assign wire7 = d1 & s0 & s1;

assign wire8 = a2 & ~s0 & ~s1;
assign wire9 = b2 & ~s0 & s1;
assign wire10 = c2 & s0 & ~s1;
assign wire11 = d2 & s0 & s1;

assign wire12 = a3 & ~s0 & ~s1;
assign wire13 = b3 & ~s0 & s1;
assign wire14 = c3 & s0 & ~s1;
assign wire15 = d3 & s0 & s1;

assign y0 = wire0 | wire1 | wire2 | wire3;
assign y1 = wire4 | wire5 | wire6 | wire7;
assign y2 = wire8 | wire9 | wire10 | wire11;
assign y3 = wire12 | wire13 | wire14 | wire15;

endmodule