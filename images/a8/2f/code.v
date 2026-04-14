module top_module(clk, rst,

		
		int_set,

		
		cfg, status, full_empty, full, empty, re, we
		);input		clk, rst;
output	[2:0]	int_set;

input	[7:0]	cfg;
input	[1:0]	status;
input		full_empty, full, empty, re, we;






reg	[2:0]	int_set;






always @(posedge clk or negedge rst)
	if(!rst)	int_set[0] <= #1 1'b0;
	else
	case(cfg[5:4])	
			
	   2'h2: int_set[0] <= #1 cfg[0] & (full_empty | (status == 2'h0));
			
	   2'h1: int_set[0] <= #1 cfg[0] & (full_empty | (status[1] == 1'h0));
			
	   2'h0: int_set[0] <= #1 cfg[0] & (full_empty | (status < 2'h3));	
	   2'h3: int_set[0] <= #1 cfg[0] & full_empty;
	endcase

always @(posedge clk or negedge rst)
	if(!rst)	int_set[1] <= #1 1'b0;
	else
	if(empty & re)	int_set[1] <= #1 1'b1;

always @(posedge clk or negedge rst)
	if(!rst)	int_set[2] <= #1 1'b0;
	else
	if(full & we)	int_set[2] <= #1 1'b1;

endmodule