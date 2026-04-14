module top_module(clk, rst, npc, pc);input clk, rst;
  input [31:0] npc;
  output reg [31:0] pc;
  
  always @(posedge clk or posedge rst)
  begin 
    if (rst == 1) pc <= 32'h0000_3000;
    else pc <= npc;
  end
endmodule