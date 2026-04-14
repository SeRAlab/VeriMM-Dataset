module top_module (
  input clk,
  input reset,
  input in,
  output reg out);parameter S0 = 1'b0, S1 = 1'b1;
reg state;
always @(posedge clk or posedge reset) begin
	if (reset)
		state <= S0;
	else
		case (state)
			S0: if (in) state <= S1;
			S1: state <= S1;
		endcase
end
always @(*) begin
	out = (state == S1) && in;
end
endmodule