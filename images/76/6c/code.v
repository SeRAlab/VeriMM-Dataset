module top_module(output reg [7:0] pointer, input clk, input offset);always @(posedge clk) begin
		pointer = pointer + offset + 1;
	end
endmodule