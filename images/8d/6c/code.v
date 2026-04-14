module top_module(
  input [31:0] a,
  input [31:0] b,
  input [1:0] mode,
  output [31:0] add_out,
  output [31:0] sub_out,
  output [31:0] mul_out,
  output [31:0] div_out
);wire [31:0] add;
  wire [31:0] sub;
  wire [31:0] mul;
  wire [31:0] div;

  assign add = a + b;
  assign sub = a - b;
  assign mul = a * b;
  assign div = a / b;

  assign add_out = (mode == 2'b00) ? add : 0;
  assign sub_out = (mode == 2'b01) ? sub : 0;
  assign mul_out = (mode == 2'b10) ? mul : 0;
  assign div_out = (mode == 2'b11) ? div : 0;

endmodule