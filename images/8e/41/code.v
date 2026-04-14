module t_ff (
  input clk,
  input reset,
  input t,
  output reg q);always @(posedge clk or posedge reset) begin
		if (reset)
			q <= 1'b0;
		else if (t)
			q <= ~q;
	end
	
endmodule