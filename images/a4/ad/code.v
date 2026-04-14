module top_module(
   input logic 	clk,
   input logic 	x,
   output logic y
   );logic 		   t;
   always_comb t = x ^ 1'b1;

   always_ff @(posedge clk) begin
      if (clk)
        y <= t;
   end
endmodule