module top_module(addr, dev);input [31:0] addr;
	output [6:0] dev;

	assign dev = addr[31:10]==0?0:addr[8:2];
endmodule