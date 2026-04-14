module top_module(input[10:0] in, input clk , input ld , input shift, output[10:0] out);reg[10:0] q;
	always @(posedge clk)
		if(ld)
			q = in;
		else if(shift)
			q = {q[10],q[10:1]};
	assign out = q;
endmodule