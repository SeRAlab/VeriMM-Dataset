module top_module(input [7:0] a, output[15:0] out);wire [7:0] sign;
  assign sign = (a[7] == 1'b1) ? 8'b11111111 : 1'b0;
  assign out = {sign, a};
endmodule