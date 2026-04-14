module top_module(A, B, S);input wire A;
input wire B;
output wire S;









assign M = (A && B);
assign N = !M;
assign S = !N;

endmodule