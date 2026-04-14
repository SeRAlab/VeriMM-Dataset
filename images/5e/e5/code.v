module top_module( in, out );input [2:0] in;
   output [7:0] out;

   
   reg [7:0] out;

   integer n;
   always @ (in) begin
      for (n = 0; n <= 7; n = n+1) begin
         if (in == n) begin
            out[n] = 1;
         end
         else begin
            out[n] = 0;
         end
      end
   end

endmodule