module top_module (
  input clk,
  input reset,
  input enable,
  input d,
  output reg q);always @(posedge clk) begin
	if (reset)
		q <= 0;
	else if (enable)
		q <= d;
end
endmodule