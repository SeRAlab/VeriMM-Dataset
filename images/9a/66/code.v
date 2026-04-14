module top_module(
   input wire clk,
   input wire ena, wea, enb, web,
   output reg out
);always @(posedge clk) begin
      if ((ena == 1) && (wea == 1) &&
	  (enb == 1) && (web == 1))
	out <= 1;
      else
        out <= 0;
   end

endmodule