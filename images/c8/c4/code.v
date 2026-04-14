module mux2to1
  (
   input a,
   input b,
   input sel,
   output reg out
   );
   
   always @ (a, b, sel) begin
     case (sel)
       0: out = a;
       1: out = b;
     endcase
   end
endmodule