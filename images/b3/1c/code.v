module top_module( a, b, sel, out );input  a, b, sel;
   output out;

   
   wire a, b, sel;
   reg  out;

   always @ (a or b or sel) begin
      if (sel) begin
         out = a;
      end
      else begin
         out = b;
      end
   end

endmodule