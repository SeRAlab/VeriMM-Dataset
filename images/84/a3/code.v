module top_module(
		key,          
		rst,          
		led           
		);input key,rst;
	output wire led;
	assign led=key;
 

endmodule