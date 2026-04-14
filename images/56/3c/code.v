module top_module(
   
   i
   );input [1:0] i;

   always_comb begin
      case (i)
        2'b00: ;
        2'b10: ;
        2'b11: ;
      endcase
   end
endmodule