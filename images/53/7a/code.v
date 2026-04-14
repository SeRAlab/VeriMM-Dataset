module top_module(input wire [31 : 0] a,input wire carry_in,output wire [31 : 0] adiv2,output wire carry_out);assign adiv2 = {carry_in, a[31 : 1]}; 
  assign carry_out = a[0]; 
 endmodule