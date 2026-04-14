module top_module(d, e, q, clk, clr);input clk;
	input e;
	input clr;
	output[7:0] q;
	input[7:0] d;

	reg[7:0] q;

	reg[7:0] r;

	always @(posedge clk)
		if(e==1)
			if(clr==1)
				r <= 8'b10101010;
			else
				begin
					r[0] <= !r[0];
					r[1] <= !r[1];
					r[2] <= !r[2];
					r[3] <= !r[3];
					r[4] <= !r[4];
					r[5] <= !r[5];
					r[6] <= !r[6];
					r[7] <= !r[7];
				end

	always @(posedge clk)
		if(e==1)
			if(clr==1)
				q <= 8'b00000000;
			else
				begin
					q <= q + r;
				end

endmodule