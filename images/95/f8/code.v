module top_module(pc_inc,inm_ext, result);input wire [31:0] pc_inc,inm_ext;
	output [31:0]  result;
	wire [31:0] inm_ext_sll;
	
	assign inm_ext_sll = inm_ext<<32'b10;
	assign result = pc_inc + inm_ext_sll;endmodule