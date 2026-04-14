module top_module(clock);input clock;

	always @ (clock) 
		begin
			$monitor("Hello world %0t\n",$realtime);
		end

endmodule