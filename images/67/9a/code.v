module parallel_load_register (
	input clk,
	input rst,
	input load,
	input [7:0] data_in,
	output reg [7:0] data_out);

	always @(posedge clk) begin
		if (rst)
			data_out <= 8'b00000000;
		else if (load)
			data_out <= data_in;
	end
	
endmodule