module top_module(rf_result_o,clk, rst, alu_result_i, lsu_result_i, ppc_i, pc_fetch_next_i,spr_i, op_jal_i, op_lsu_load_i, op_mfspr_i);parameter OPTION_OPERAND_WIDTH = 32; 
  input clk, rst; 
  input [OPTION_OPERAND_WIDTH-1:0] alu_result_i; 
  input [OPTION_OPERAND_WIDTH-1:0] lsu_result_i; 
  input [OPTION_OPERAND_WIDTH-1:0] ppc_i; 
  input [OPTION_OPERAND_WIDTH-1:0] pc_fetch_next_i; 
  input [OPTION_OPERAND_WIDTH-1:0] spr_i; 
  output [OPTION_OPERAND_WIDTH-1:0] rf_result_o; 
  input op_jal_i; 
  input op_lsu_load_i; 
  input op_mfspr_i; 
  assign rf_result_o = op_lsu_load_i ? lsu_result_i : 
  op_mfspr_i ? spr_i : 
  op_jal_i ? pc_fetch_next_i: 
  alu_result_i; 
 endmodule