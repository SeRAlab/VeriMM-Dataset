module top_module(input s, r,
		  output reg q=0);always @(posedge s, posedge r) begin
		if(s) q <= ~q;
		else q <= ~q;
		
		end 

endmodule