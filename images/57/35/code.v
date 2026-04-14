module top_module(S,cout,A,B,cin);input [3:0]A,B;
input cin;
output [3:0]S;
output cout;

wire p0,g0,p1,g1,p2,g2,p3,g3;
wire c1,c2,c3;

assign p0 = A[0]^B[0],
       p1 = A[1]^B[1],
       p2 = A[2]^B[2],
       p3 = A[3]^B[3];

assign g0 = A[0]&B[0],
       g1 = A[1]&B[1],
       g2 = A[2]&B[2],
       g3 = A[3]&B[3];

assign c1 = g0|(p0&cin),
       c2 = g1|(p1&g0)|(p1&p0&cin),
       c3 = g2|(p2&g1)|(p2&p1&g0)|(p2&p1&p0&cin),
       cout = g3|(p3&g2)|(p3&p2&g1)|(p3&p2&p1&g0)|(p3&p2&p1&p0&cin);

assign S[0] = p0^cin,
       S[1] = p1^c1,
       S[2] = p2^c2,
       S[3] = p3^c3;

endmodule