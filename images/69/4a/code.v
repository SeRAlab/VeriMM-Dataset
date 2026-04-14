module top_module(
	input [4:0] wr_addr,
	input [4:0] rd_addr,
	input clk, 
	input clk_en,
	input [43:0] data,
	output reg [43:0] q
);reg [43:0] ram[31:0];

	always @ (posedge clk) if(clk_en) begin
		q <= ram[rd_addr];
		ram[wr_addr] <= data;
	end

endmodule