module top_module(enable_output, clk, devider_reset);output enable_output;
    input clk, devider_reset;
	 
	 reg enable_output;
	 reg sys_tick_count;
	 parameter one_second_count = 25'd26_999_999;
	 
	 always @ (posedge clk)
		begin
			
			enable_output <= 0;				
			
			if(sys_tick_count == one_second_count || devider_reset == 1)
				sys_tick_count <= 25'd0;
			else
				sys_tick_count <= sys_tick_count + 1;
				
			if(sys_tick_count == one_second_count)
				enable_output <= 1;
				
		end
	 
endmodule