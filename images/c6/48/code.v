module add_subtract (
   input [7:0] a,
   input [7:0] b,
   input sel,
   output reg [7:0] out
   );

   always @ (a, b, sel) begin
      if (sel == 1) begin
         out = a + b;
      end else begin
         out = a - b;
      end
   end

endmodule