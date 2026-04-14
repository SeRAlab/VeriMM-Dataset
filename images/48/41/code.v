module top_module(
  intr,  
  paddr,
  pclk,
  penable,
  pprot,
  prdata,
  psel,
  pwdata,
  pwrite,
  presetn
);input   [31:0]  paddr;        
input           pclk;         
input           penable;      
input   [2 :0]  pprot;        
input           psel;         
input   [31:0]  pwdata;       
input           pwrite;       
input           presetn;   
output  [31:0]  prdata; 
output          intr;  
assign prdata[31:0] = 32'h0;
assign intr = 1'b0;endmodule