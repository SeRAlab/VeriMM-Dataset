module top_module(op_code,is_valid);input  wire[3:0] op_code;
	output wire is_valid;
	
	 
	assign is_valid = (~(op_code[2] & op_code[3])) & 
	                  (|(op_code ^ 4'b0100)) & 
							(|(op_code ^ 4'b1011));

endmodule