module top_module(
	   input vconst,
	   input clk,
	   output reg q);always @ (posedge clk) begin
      q <= vconst;
   end
endmodule