module top_module(sh_a, sh_y);input  [31:0]  sh_a;          
  output  [7:0]  sh_y;          

  
  
  assign sh_y = {sh_a[5:0], 2'b00};
endmodule