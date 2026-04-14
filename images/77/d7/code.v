module top_module(
			input 			clk,
			input 			rst,
			input 			id_flush,
			input 			id_stall,
			input 		[31:0]	if_pc,
			input 		[ 3:0]	if_exception_i,
		        input 			if_trap_valid,
			input 		[31:0]	if_exc_data,	
			input 		[31:0]	if_inst,
	       		output reg 	[31:0] 	id_pc,
			output reg 	[ 3:0]	if_exception_o,
			output reg 	[31:0] 	id_inst,
			output reg	[31:0]	id_exc_data,	
			output reg 		id_trap_valid	);always 	@(posedge clk) begin
			id_pc  	       	<= ((rst|id_flush)? 32'b0  :((id_stall)? id_pc   : if_pc ));  
			id_inst        	<= ((rst|id_flush)? 32'h33 :((id_stall)? id_inst : if_inst)); 
			if_exception_o 	<= ((rst|id_flush)? 4'b0   :((id_stall)? if_exception_o : if_exception_i)); 
			id_trap_valid	<= ((rst|id_flush)? 1'b0   :((id_stall)? id_trap_valid : if_trap_valid)); 
			id_exc_data	<= ((rst|id_flush)? 32'b0  :((id_stall)? id_exc_data : if_exc_data)); 
		end
endmodule