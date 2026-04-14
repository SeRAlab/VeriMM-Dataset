module top_module(clk, addr_r, data_r, addr_w, data_w, we);parameter SIZE = 1024;
	parameter WIDTH = $clog2(SIZE);

	input clk;
	input [WIDTH-1:0] addr_r;
	input [WIDTH-1:0] addr_w;
	input [7:0] data_w;
	input we;

	output [7:0] data_r;

	reg [7:0] mem [SIZE-1:0];
	reg [WIDTH-1:0] addr_r_sync;

	assign data_r = mem[addr_r_sync];

	always @(posedge clk) begin
		if (we)
			mem[addr_w] <= data_w;
		addr_r_sync <= addr_r;
	end
endmodule