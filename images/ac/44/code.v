module top_module(input signed [7:0] A,B,
                   input clk,reset,start,
                   output reg done,
                   output reg signed [14:0] result);always@(posedge clk) begin
		if(reset) begin
			result <= 0;
		    done <= 0;
		end
		else begin
			if(start) begin
				result <= (A*B)>>>8;
				done <= 1;
			end
			else begin
				result <= 0;
				done <= 0;
			end
		end
	 end
    
endmodule