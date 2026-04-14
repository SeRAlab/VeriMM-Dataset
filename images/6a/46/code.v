module top_module(
   
   out1, out2,
   
   in1, in2
   );input      [15:0] in1;
   input      [15:0] in2;
   output reg signed [31:0] out1;
   output reg unsigned [31:0] out2;

   always @* begin
      
      out1 = $signed(in1) * $signed(in2);
      out2 = $unsigned(in1) * $unsigned(in2);
      
   end

endmodule