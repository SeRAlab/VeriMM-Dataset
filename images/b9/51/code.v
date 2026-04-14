module top_module(input i0 , input i1 , input sel , output y);assign y = sel?i1:i0;
	endmodule