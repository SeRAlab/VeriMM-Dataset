module decoder4to16 (
  input [3:0] in,
  input en,
  output [15:0] out
);

  assign out = en ? (1 << in) : 16'b0;

endmodule