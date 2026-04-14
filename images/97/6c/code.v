module top_module(in, enable, clock, reset, out);input in, enable, clock, reset;
	output out;
	reg out;
	
	always @ (posedge clock or posedge reset) begin
		if (reset) begin
			out <= 1'b0;
		end 
		else if (enable) begin
			out <= in;
		end	
	end
endmodule