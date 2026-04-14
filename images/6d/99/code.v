module johnson_counter (
  input clk,
  input reset,
  output reg [2:0] q);always @(posedge clk or posedge reset) begin
		if (reset)
			q <= 3'b0;
		else
			q <= {~q[2], q[2:1]};
	end
	
endmodule