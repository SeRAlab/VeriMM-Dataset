module top_module (
  input clk,
  input enable,
  input clear,
  output reg [2:0] q);always @(posedge clk) begin
		if (clear)
			q <= 3'b000;
		else if (enable)
			q <= q + 1;
	end
endmodule