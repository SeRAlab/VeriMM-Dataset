module top_module(pc, pc_inc);input wire [31:0] pc;
	output [31:0] pc_inc;
	
	assign pc_inc = pc + 32'b100;endmodule