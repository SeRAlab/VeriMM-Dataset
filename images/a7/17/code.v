module top_module(enable,s,a,b,c);input a,b,c, enable;
	output reg s;

	always @(enable)
		s = exp(a,b,c);

		function exp;
			input a,b,c;
			begin
				exp = (~((a&b) | c));
			end
		endfunction
endmodule