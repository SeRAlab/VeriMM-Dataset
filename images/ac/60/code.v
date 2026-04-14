module top_module(W,X,Y,Z,c);input W,X,Y,Z;
output c;
wire g1, g2, g3, g4;

assign g1 = ~W;
assign g2 = ~X;
assign g3 = ~Y;
assign g4 = ~Z;

assign c = (g1&g3) | (g2&g3) | (g1&g2&Z) | (g1&X&g4);endmodule