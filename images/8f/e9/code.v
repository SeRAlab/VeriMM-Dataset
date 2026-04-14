module top_module(input clk_i,input rst_i,input stall_i,input take_branch_i,input [29:0] branch_pc_i,output [31:0] ir_o,output [29:0] nextpc_o,output reg re_o,output [29:0] rmemaddr_o,input [31:0] rmemdata_i);reg [29:0] pc; 
 initial begin 
  pc = 0; 
 end 
 assign nextpc_o = take_branch_i ? branch_pc_i : pc + 30'b1; 
 assign rmemaddr_o = nextpc_o; 
 assign ir_o = rmemdata_i; 
 always @(posedge clk_i) 
 begin 
  re_o = 0; 
  if (rst_i) begin 
  pc <= 30'b111111111111111111111111111111; 
  re_o = 1; 
  end else if (!stall_i) begin 
  pc <= nextpc_o; 
  re_o = 1; 
  end 
 end 
 endmodule