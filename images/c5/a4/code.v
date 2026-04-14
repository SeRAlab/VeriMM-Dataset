module signal_repeater (
   input [135:0] in,
   output [135:0] out
   );

   always @(*) begin
      out = in;
   end

endmodule