module top_module(input wire clk,
   output reg foo, bar,
   input wire foo_valid, foo_in,
   input wire bar_valid, bar_in
   );always @(posedge clk)
     begin
	if (foo_valid) foo <= foo_in;
	if (bar_valid) bar <= bar_in;
     end

endmodule