module top_module(in, out);input [15:0] in;
	output reg [31:0] out;

	always @ (in)
	begin
		
		
		if(in[15] == 1) begin
			out <= 32'hFFFF0000 | in;
		end else begin
			out <= in;
		end
	end

endmodule