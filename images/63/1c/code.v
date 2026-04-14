module top_module(input A,B, output reg out);always @(*) begin
		out <= A & B;
	end
endmodule