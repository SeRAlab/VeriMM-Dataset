module top_module(enable, clk, rst, out1
    );input enable;
	 input clk;
	 input rst;
	 output out1;
	 
	 parameter DIVIDE_BITS=4;
	 parameter DIVIDE=10;
	 parameter CLEAR_COUNT=5;
	 
	 reg out1;
	 reg [DIVIDE_BITS-1:0] counter, clear_counter;
	 
	 always @(posedge clk or posedge rst)
	 begin
		
		if (rst)
		begin
			out1 <= 1'b0;
			counter <= 0;
			clear_counter <= 0;
		end
		else if (enable == 1'b1)
		begin
			
			if (out1 == 1'b1)
			 begin
					clear_counter <= clear_counter + 1'b1;
					if (clear_counter == CLEAR_COUNT)
					begin
						out1 <= 1'b0;
						clear_counter <= 0;
					end
			 end
 		   
			if (counter == DIVIDE)
			 begin
				out1 <= 1'b1;
				counter <= 0;
			 end
			else 
			 begin
				 counter <= counter + 1'b1;
			 end
		end 
	end 
		
endmodule