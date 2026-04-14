module top_module(addr,inst);input [15:0] addr;
output [15:0] inst;

reg [15:0] mem [65535:0];

assign inst = mem [addr];

endmodule