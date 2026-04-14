module top_module(
	input clk,
	input hi_value,
	input lo_value,
	output reg hi_val,
	output reg lo_val
	
    );always @(posedge clk) 
	 begin
		hi_val = hi_value;
		lo_val = lo_value;
	 end


endmodule