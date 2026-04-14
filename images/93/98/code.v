module top_module(
   input      clock,
   input      in,
   output reg out = 0
   );reg 	      in_prev = 0;
   always @(posedge clock)
     begin
	in_prev <= in;
	out <= in & ~in_prev;
     end
endmodule