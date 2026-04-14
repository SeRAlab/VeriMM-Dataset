module top_module( input      sel,
                  input      clka,
                  input      clkb,
                  output reg clkout
                );always @(*)
 begin
     case (sel) 
         1'b0    : clkout = clka;
         1'b1    : clkout = clkb;
         default : clkout = clka;
     endcase
 end

endmodule