module top_module(in_4, out_2);input [3:0] in_4;
  output [1:0] out_2;
  
  wire msb_1 = in_4[3];
  wire msb_2 = in_4[2];
  
  wire sum = msb_1 | msb_2;
  
  assign out_2 = {sum, sum};
endmodule