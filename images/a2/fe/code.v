module top_module(rst, clk, ld, d, q);input rst, clk, ld, d; 
	output q;
	reg temp;
	
	always @ (posedge clk)
		if (rst) 
			temp = 1'b0;
		else if (ld)
    		temp = d;
	
	assign q = temp;
endmodule