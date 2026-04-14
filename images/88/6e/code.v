module top_module(
  input  wire EXTRSTn,  
  input  wire EXTCLK,   
  input  wire rsten,    
  input  wire clken,    
  output wire SYSRSTn,  
  output wire SYSCLK    
);reg sysrstn;
  assign SYSRSTn = sysrstn;

  always @ (negedge EXTRSTn or posedge EXTCLK)
    if(!EXTRSTn)
      sysrstn <= 1'b0;
    else
      sysrstn <= rsten ? EXTRSTn : 1'b0;

      
  reg clk_latch;
  assign SYSCLK = clk_latch && EXTCLK;

  always @ (EXTCLK or clken)
    if(!EXTCLK)
      clk_latch <= clken;

endmodule