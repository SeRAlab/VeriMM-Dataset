module top_module(
	input 				clk,
	input 				reset,
	input			[7:0]	max,
	input					up,
	input					down,
	input					en,
	output reg 	[7:0]	q);always @(posedge clk)
		if (reset)
			q = 0;
		else if (en)
			if ( !(up && down))
				if(( up) && (q != max))
					q = q + 1;
				else if ( (down) && (q != 0))
					q = q - 1;

	
endmodule