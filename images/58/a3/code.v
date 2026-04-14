module top_module(Clear, Clock, Q);input Clear, Clock;
		output reg [1:0] Q;

		always @(posedge Clock)
			if (Clear)
				Q <= 0;
			else
				Q <= Q + 1;endmodule