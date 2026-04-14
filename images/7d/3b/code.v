module top_module(sw, clock, portout);input [9:0]sw;
input clock;
output reg [15:0]portout;

always @(posedge clock)
	portout <= {5'b0,sw};endmodule