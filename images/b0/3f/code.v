module register (
  input clk,
  input clr,
  input [15:0] d,
  output reg [15:0] q);always @(posedge clk) begin
		if (clr)
			q <= 16'b0;
		else
			q <= d;
	end
endmodule