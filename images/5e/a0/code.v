module top_module(input [3:0] in, output reg [2:0] out);always @(*) begin
		if (in <= 4) begin
			out = in[2:0];
		end
		else begin
			out = {1'b1, in[2:0]};
		end
	end
endmodule