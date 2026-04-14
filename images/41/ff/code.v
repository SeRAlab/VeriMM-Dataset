module top_module(
	input 		 rst,
	input 		 clk,

	input 		 do_exception,

	input 		 mem_stall,
	input [31:0] 	 mem_pc,
	input [31:0] 	 mem_alu_result,
	input [31:0] 	 mem_lsu_result,
	input 		 mem_rf_r_we,
	input [4:0] 	 mem_rf_r_addr,

	input 		 mem_op_load,

	input 		 wb_op_mul,
	input [31:0] 	 wb_mul_result,

	output [31:0] 	 wb_rf_r,
	output reg 	 wb_rf_r_we,
	output reg [4:0] wb_rf_r_addr
);reg [31:0]	wb_result;

always @(posedge clk)
	if (!mem_stall | do_exception) begin
		if (do_exception)
			wb_result <= mem_pc;
		else if (mem_op_load)
			wb_result <= mem_lsu_result;
		else
			wb_result <= mem_alu_result;

		if (do_exception)
			wb_rf_r_addr <= 5'd30;
		else
			wb_rf_r_addr <= mem_rf_r_addr;

		wb_rf_r_we <= mem_rf_r_we | do_exception;
	end

assign wb_rf_r = wb_op_mul ? wb_mul_result : wb_result;

endmodule