module top_module(clk, pc_we, pc_next, pc);input clk; 
  input pc_we; 
  input [31:0] pc_next; 
  output reg [31:0] pc; 
  always @(posedge clk) begin 
  if (pc_we == 1) begin 
  pc <= pc_next; 
  end 
  end 
 endmodule