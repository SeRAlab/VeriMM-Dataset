module top_module(PL, JB, BC, Z, N, K);input PL, JB, BC, Z, N;
output [1:0] K;
assign K[1] = PL & ~JB & ~BC & Z | PL & ~JB & BC & N;
assign K[0] = PL & JB;
endmodule