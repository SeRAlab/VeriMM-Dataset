module top_module(Cin, A, B, C, p, g);input Cin;
input [3:0] A;
input [3:0] B;
output [3:0] C;
output [3:0] p; 
output [3:0] g;

reg p0, p1, p2, p3;
reg g0, g1, g2, g3;


always @(*) begin
  p0 <= (A[0] + B[0]);
  p1 <= (A[1] + B[1]);
  p2 <= (A[2] + B[2]);
  p3 <= (A[3] + B[3]);

  g0 <= (A[0] & B[0]);
  g1 <= (A[1] & B[1]);
  g2 <= (A[2] & B[2]);
  g3 <= (A[3] & B[3]);
end

  assign C[0] = g0 + (p0&Cin); 
  assign C[1] = g1 + (p1&g0) + (p1&p0&Cin); 
  assign C[2] = g2 + (p2&g1) + (p2&p1&g0) + (p2&p1&p0&Cin); 
  assign C[3] = g3 + (p3&g2) + (p3&p2&g1) + (p3&p2&p1&g0) + (p3&p2&p1&p0&Cin); 
  assign p = {p0,p1,p2,p3};
  assign g = {g0,g1,g2,g3};endmodule