module top_module( i, o);input      [1:0] i;
   output reg [1:0] o;

    
   always @* begin
     if      (i==2'b00) o = 2'b11;
     else if (i==2'b01) o = 2'b10;
     else if (i==2'b10) o = 2'b01;
     else if (i==2'b11) o = 2'b00;
     else               o = 2'b00; 
   end

endmodule