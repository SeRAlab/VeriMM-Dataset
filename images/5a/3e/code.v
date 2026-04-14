module memory (
	input clk,
	input read_en,
	input write_en,
	input [2:0] addr,
	input [3:0] data_in,
	output reg [3:0] data_out);
	
	reg [3:0] mem [7:0];
	
	always @(posedge clk) begin
		if (write_en)
			mem[addr] <= data_in;
		if (read_en)
			data_out <= mem[addr];
	end

endmodule