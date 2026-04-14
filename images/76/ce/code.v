module top_module(
  in_a,
  in_b,
  out
);input wire [15:0] in_a;
input wire [15:0] in_b;
output wire [31:0] out;

assign out = {in_a, in_b};

endmodule