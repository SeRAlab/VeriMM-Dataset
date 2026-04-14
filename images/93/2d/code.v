module top_module(
input wire a,
input wire b,
input wire ci,
output reg s,
output reg co
);always @ (*)
		{co, s} = a + b + ci;

endmodule