module top_module(a, b, sel, out);input a, b, sel;
output reg out; // Change output to reg to allow assignment in always block

   always @ (*)
   begin
      if (sel == 0)
         out = a;
      else
         out = b;
   end

endmodule