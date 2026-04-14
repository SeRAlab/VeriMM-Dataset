module top_module(
	north,
	west,
	south,
	east,
	request,
	grant,
	);input wire north, request, west;
output wire south, grant, east;

assign grant = north & request & west;
assign south = north & ~(north & request & west);
assign east  = west  & ~(north & request & west);

endmodule