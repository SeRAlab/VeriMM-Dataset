module top_module(WB_result,ALU_result,read_mem_data,mem_to_reg);output [31:0] WB_result;
input [31:0] read_mem_data;
input [31:0] ALU_result;
input mem_to_reg;

assign WB_result = mem_to_reg ? read_mem_data : ALU_result;
endmodule