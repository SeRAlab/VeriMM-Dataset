module top_module(clk, in, pose, nege);parameter BITS = 2;
  input clk, in;
  output pose, nege;
  reg [BITS - 1:0] shift_bits;

  always @(posedge clk) shift_bits <= {in, shift_bits[BITS - 1:1]};
  assign pose = shift_bits[1:0] == 2'b10;
  assign nege = shift_bits[1:0] == 2'b01;
endmodule