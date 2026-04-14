module top_module(A, B, sel, C);parameter WIDTH = 8;
   input [WIDTH-1:0] A, B;
   input sel;
   output [WIDTH-1:0] C;

   reg [WIDTH-1:0]    C_reg;

   always @(*)
   begin
      if (sel == 0)
         C_reg = A + B;
      else
         C_reg = A - B;
   end

   assign C = C_reg;
endmodule