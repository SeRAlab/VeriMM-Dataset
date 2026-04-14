module top_module(input wire [31 : 0] a,input wire carry_in,output wire [31 : 0] amul2,output wire carry_out);assign amul2 = {a[30 : 0], carry_in}; 
  assign carry_out = a[31]; 
 endmodule