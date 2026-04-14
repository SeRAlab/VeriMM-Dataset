module top_module(
  input [3:0] data,
  output [1:0] q,
  output zero
);wire [1:0] priority_bits;
  assign priority_bits[0] = (data[1:0] != 2'b00) ? 1'b1 : 1'b0;
  assign priority_bits[1] = (data[3:2] != 2'b00) ? 1'b1 : 1'b0;

  assign q = {~priority_bits[1], ((priority_bits[1] & priority_bits[0]) | (~priority_bits[1] & priority_bits[1]))};
  assign zero = (data == 4'b0000) ? 1'b1 : 1'b0;

endmodule