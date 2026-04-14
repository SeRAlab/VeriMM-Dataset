module top_module(input D, input clk, rst, output reg Q);always @(posedge clk) begin
		Q = rst ? 0 : D;
	end
endmodule