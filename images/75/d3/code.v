module top_module( input d, clk, rst, en, output reg q );always @( posedge clk)
		if(en)
			if (rst)
				q <= 0;
			else
				q <= d;
endmodule