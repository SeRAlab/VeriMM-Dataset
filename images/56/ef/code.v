module top_module(input clk,input rst,input [31:0] mem_read_data,input [31:0] mem_alu_data,input [4:0] mem_gpr_wa,input mem_mem_to_gpr_select,input mem_gpr_we,input mem_flush,input mem_stall,input wb_stall,output reg [31:0] wb_read_data,output reg [31:0] wb_alu_data,output reg [4:0] wb_gpr_wa,output reg wb_mem_to_gpr_select,output reg wb_gpr_we);always @(posedge clk) begin 
  wb_read_data <= (rst) ? 31'b0 : ((wb_stall) ? wb_read_data : mem_read_data); 
  wb_alu_data <= (rst) ? 31'b0 : ((wb_stall) ? wb_alu_data : mem_alu_data); 
  wb_gpr_wa <= (rst) ? 5'b0 : ((wb_stall) ? wb_gpr_wa : mem_gpr_wa); 
  wb_mem_to_gpr_select <= (rst) ? 1'b0 : ((wb_stall) ? wb_mem_to_gpr_select : mem_mem_to_gpr_select); 
  wb_gpr_we <= (rst) ? 1'b0 : ((wb_stall) ? wb_gpr_we : ((mem_stall | mem_flush) ? 1'b0 : mem_gpr_we)); 
  end 
 endmodule