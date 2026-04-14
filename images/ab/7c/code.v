module top_module(LEFT16, RIGHT16, LEFT_SWAP, RIGHT_SWAP);input [1 : 32]LEFT16;
input [1 : 32]RIGHT16;
output [1 : 32]LEFT_SWAP;
output [1 : 32]RIGHT_SWAP;
wire [1 : 32]LEFT16;
wire [1 : 32]RIGHT16;
wire [1 : 32]LEFT_SWAP;
wire [1 : 32]RIGHT_SWAP;
assign LEFT_SWAP = RIGHT16;
assign RIGHT_SWAP = LEFT16;endmodule