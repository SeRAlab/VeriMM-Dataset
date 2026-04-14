module top_module(clk, reset, port, out, write);parameter inSize = 6, outSize = 32;

	input clk, reset;
	input [inSize-1:0] port; 

	output reg [outSize-1:0] out = 0; 
	output reg write = 0;

	reg [outSize/inSize:0] received = 0;
	reg clear = 0;
	reg valid = 1;

	always @(posedge clk) begin
		write = 0;

		if (reset) begin
			out <= 0;
			received <= 0;
			clear <= 0;
			valid <= 1;
		end else if (received < (outSize/inSize + 1)) begin
			out <= (out << inSize) | port;
			received <= received+1;
		end else if (port) begin
			valid <= 0;
		end else begin
			if (valid)
				write = 1;
			received <= 0;
			valid <= 1;
		end
	end
endmodule