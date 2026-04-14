module top_module( clk, clrn, NPC, PC );input              clk;
  input              clrn;
  input       [31:0] NPC;
  output reg  [31:0] PC;

  always @(posedge clk, negedge clrn)
    if (clrn==0) 
      PC <= 32'h0000_0000;

    else
      PC <= NPC;
      
endmodule