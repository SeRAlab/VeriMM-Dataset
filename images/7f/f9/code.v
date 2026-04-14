module top_module(input clk,input rst,input [31:0] if_instruction,input [31:0] if_pc_add4,input [31:0] if_pc,input if_is_bds,input if_flush,input if_stall,input id_stall,output reg [31:0] id_instruction,output reg [31:0] id_pc_add4,output reg [31:0] id_exception_pc,output reg id_is_bds,output reg id_is_flushed);always @(posedge clk) begin 
  id_instruction <= (rst) ? 32'b0 : ((id_stall) ? id_instruction : ((if_stall | if_flush) ? 32'b0 : if_instruction)); 
  id_pc_add4 <= (rst) ? 32'b0 : ((id_stall) ? id_pc_add4 : if_pc_add4); 
  id_exception_pc <= (rst) ? 32'b0 : ((id_stall) ? id_exception_pc : if_pc); 
  id_is_bds <= (rst) ? 1'b0 : ((id_stall) ? id_is_bds : if_is_bds); 
  id_is_flushed <= (rst) ? 1'b0 : ((id_stall) ? id_is_flushed : if_flush); 
  end 
 endmodule