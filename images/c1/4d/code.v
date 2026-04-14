module signal_filter(input clk, input in, output reg out);
	always @(posedge clk) begin
		out <= in;
	end
endmodule