module top_module(input d, clk, clr, output qbar, output reg q);assign qbar = ~q;
	always@(posedge clk, negedge clr)
	begin
		if(!clr) q<=0;
		else q<= d;
	end
endmodule