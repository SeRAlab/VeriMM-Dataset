module top_module(
	    input clk,
	    output wire signed [2:0] sgn,
	    output wire [2:0] unsgn,
	    input signed [7:0] iss,
	    input signed [7:0] isu,
	    input [7:0] ius,
	    input [7:0] iuu);assign sgn = 3'sh7;
   assign unsgn = 3'h7;
   always @ (posedge clk) begin
`ifdef TEST_VERBOSE
      $write("in: %x %x %x %x\n", iss, isu, ius, iuu);
      if (iss != 8'hff) $stop;
      if (isu != 8'h07) $stop;
      if (ius != 8'hff) $stop;
      if (iuu != 8'h07) $stop;
`endif
   end

endmodule