module top_module(in, out);input [3:0] in;
output reg [1:0] out; // Change to output reg to allow assignment in an always block

	always @(*)
	begin
		if (in % 2 == 0) // If the input is even
			out = in[1:0] * 2; // Ensure the output fits in 2 bits
		else // If the input is odd
			out = in[1:0] / 2; // Ensure the output fits in 2 bits
	end

endmodule