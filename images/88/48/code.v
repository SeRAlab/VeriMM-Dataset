module top_module(
  input [3:0] A,
  input [3:0] B,
  output [3:0] SUM,
  output CARRY
);wire [3:0] x;
  wire [3:0] y;
  wire [3:0] z;
  wire [3:0] g;
  wire [3:0] p;
  wire [3:0] c;

  assign x = A ^ B;
  assign y = A & B;

  assign g[0] = x[0] & 1'b1;
  assign p[0] = y[0] | (x[0] & 1'b1);
  assign c[0] = g[0] | (p[0] & 1'b0);

  assign g[1] = x[1] & c[0];
  assign p[1] = y[1] | (x[1] & c[0]);
  assign c[1] = g[1] | (p[1] & c[0]);

  assign g[2] = x[2] & c[1];
  assign p[2] = y[2] | (x[2] & c[1]);
  assign c[2] = g[2] | (p[2] & c[1]);

  assign g[3] = x[3] & c[2];
  assign p[3] = y[3] | (x[3] & c[2]);
  assign CARRY = g[3] | (p[3] & c[2]);

  assign z = x & c;
  assign SUM = z ^ c;

endmodule