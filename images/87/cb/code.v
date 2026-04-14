module top_module(A, B, op, Sign, S, Z, V, N);input [31:0] A, B;
reg [31:0] BB;
input op, Sign;
output Z, V, N;
output [31:0] S;
reg [32:0] Sum;
wire V_Sign;
always @(*) begin BB = B;
if (Sign)
  begin if (op) begin BB = ~B + 1;
end end Sum = A + BB;
end assign V_Sign = (A[31] == BB[31]) ? Sum[32] ^ Sum[31] : 0;
assign V = (~Sign) ? Sum[32] : V_Sign;
assign S = Sum [31:0];
assign Z = ~(| S);
assign N = (Sign) ? S[31] : 0;endmodule