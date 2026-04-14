module top_module(output wire y,
	   input wire x,
	   input wire clk);reg r = 0;
   assign y = r;

   always @(posedge clk) begin
      r = x ? ~x : y;
   end

endmodule