module top_module(
   // Outputs
   muxed,
   // Inputs
   sa, sb, a, b
   );input sa, sb;
   input [71:0] a, b;
   output [71:0] muxed;

   wire [71:0] not_a = ~a;
   wire [71:0] not_b = ~b;

   assign muxed = (sa == 0 && sb == 0) ? a :
                  (sa == 0 && sb == 1) ? b :
                  (sa == 1 && sb == 0) ? not_a :
                  (sa == 1 && sb == 1) ? not_b : 0;
endmodule