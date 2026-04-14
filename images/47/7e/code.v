module top_module (
	input clk,
	input load,
	input [7:0] data_in,
	output reg [7:0] data_out);always @(posedge clk) begin
		if (load)
			data_out <= data_in;
		else
			data_out <= {data_out[6:0], 1'b0};
	end
	
endmodule