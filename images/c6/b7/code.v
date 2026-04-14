module mux_2to1(
   input a,
   input b,
   input sel,
   output reg out
);

   always @(*) begin
      if (sel == 1'b1) begin
         out = a;
      end
      else begin
         out = b;
      end
   end

endmodule