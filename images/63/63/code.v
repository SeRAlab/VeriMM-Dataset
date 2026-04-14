module top_module(
	input [63:0] x,
	input [2:0] y,
	output [63:0] product
);wire [63:0] minus_x = -x;
assign product = 0 & {64{y[2:0] == 3'b000}}
					| x & {64{y[2:0] == 3'b001}}
					| x & {64{y[2:0] == 3'b010}}
					| {x[62:0], 1'b0} & {64{y[2:0] == 3'b011}}
					| {minus_x[62:0], 1'b0} & {64{y[2:0] == 3'b100}}
					| minus_x & {64{y[2:0] == 3'b101}}
					| minus_x & {64{y[2:0] == 3'b110}}
					| 0 & {64{y[2:0] == 3'b111}}
					;endmodule