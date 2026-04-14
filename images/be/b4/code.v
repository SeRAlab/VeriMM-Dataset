module top_module(sw,clk1k,r);input sw, clk1k;
	output reg r;
	
	
	reg s[1:0];
	
	
	always@(posedge clk1k) begin
		s[1] <= s[0] & sw;
		s[0] <= sw;
		r    <= ~s[1] & s[0];
	end
	
	
	
endmodule