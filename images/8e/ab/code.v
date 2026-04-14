module top_module (
  input clk,
  input reset,
  input in,
  output reg pulse);reg in_delayed;
always @(posedge clk or posedge reset) begin
	if (reset) begin
		in_delayed <= 0;
		pulse <= 0;
	end else begin
		pulse <= in & ~in_delayed;
		in_delayed <= in;
	end
end
endmodule