module top_module(q, qBar, D, clk);input D, clk;
	output q, qBar;
	reg q;
	not n1 (qBar, q);
		always@ (posedge clk)
		begin
			q <= D;
		end
endmodule