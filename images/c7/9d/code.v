module MUX2to1 (a, b, sel, out);
input a, b, sel;
output out;

   always @ (*)
   begin
      if (sel == 0)
         out = a;
      else
         out = b;
   end

endmodule