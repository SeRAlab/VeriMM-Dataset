module reset_sequential_module_with_rst (
	input clock,
	input rst, 
	output reg s,
	output reg t);always @(negedge clock or posedge rst)
	if (rst)
		s <= 0;
	else
		s <= rst;
		
always @(posedge clock or posedge rst)
	if (rst)
		t <= 0;
	else
		t <= rst;
endmodule