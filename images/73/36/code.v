module top_module(pi0, pi1, pi2, pi3, pi4, pi5, pi6, pi7, pi8, po0);input pi0, pi1, pi2, pi3, pi4, pi5, pi6, pi7, pi8;
output po0;
wire w0, w1, w2, w3;
assign w0 = (pi0 & pi1) | (pi0 & pi2) | (pi1 & pi2);
assign w1 = (pi3 & pi4) | (pi3 & pi5) | (pi4 & pi5);
assign w2 = (pi6 & pi7) | (pi6 & pi8) | (pi7  & pi8);
assign w3 = (w0 & w1) | (w0 & w2) | (w1 & w2);
assign po0 = w2 & w3;
endmodule