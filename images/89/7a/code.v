module top_module(
	input resetn, 
	input startn,
	input [5:0] current_state,
	input edge_go,
	input offset_increase,
	input clk,
	
	output reg [5:0] offset);always @(posedge clk)
		begin	
			if(!resetn | (!startn & current_state == 5'd0)) 
				offset <= 5'd0; 
			else if(edge_go)
				offset <= 5'd0;
			else if(offset_increase)
				offset <= offset + 1'b1;
		end

	 endmodule