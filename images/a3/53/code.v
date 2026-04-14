module top_module(input wire load, drain,
	    input wire clk, data,
	    output reg foo_nxt, bar_nxt);reg		       foo, bar;

   (* ivl_combinational *)
   always @* begin
      foo_nxt = foo;
      bar_nxt = bar;

      if (load) begin
	 foo_nxt = data;
	 bar_nxt = 1;
      end else if (drain) begin
	 bar_nxt = 0;
      end
   end

   always @(posedge clk) begin
      foo <= foo_nxt;
      bar <= bar_nxt;
   end

endmodule