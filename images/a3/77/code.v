module top_module(data_out, data_in, sample, clk, rst);output reg [7:0] data_out;
	input [3:0] sample;
	input data_in, clk, rst; 

	always @(posedge clk) begin
		if (!rst) begin
			data_out <= 8'b0;
		end else begin
			if (sample == 6) begin
				data_out <= data_out << 1;
				data_out[0] <= data_in;
			end
		end
	end
endmodule