module top_module(
	input [7:0] data,
	input [5:0] read_addr, write_addr,
	input we, clk,
	output reg [7:0] q
);reg [7:0] ram[63:0];

	always @ (posedge clk)
	begin
		
		if (we)
			ram[write_addr] <= data;

		
		
		
		
		q <= ram[read_addr];
	end

endmodule