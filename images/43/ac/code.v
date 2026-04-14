module sequential_module (
	input clock,
	input rst, 
	output reg a,
	output reg b,
	output reg c);always @(negedge clock or posedge rst)
	if (rst)
		a <= 0;
	else
		a <= rst;
		
always @(posedge clock or posedge rst)
	if (rst)
		b <= 0;
	else
		b <= rst;

always @(negedge clock or posedge rst)
	if (rst)
		c <= 0;
	else
		c <= rst;
endmodule