module top_module(D, clk, Q, Qbar, clr);input D, clk, clr;
	output Q, Qbar;
	reg Q;
	assign Qbar = ~Q;
	always@(posedge clk)
	begin
		if(clr == 0) Q<= 0;
		else Q <= D;
	end
endmodule