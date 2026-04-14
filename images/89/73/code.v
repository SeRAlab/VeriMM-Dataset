module top_module( input a , b , c, input [1:0] s ,output reg out);always @(*) 
begin
     if (s==2'b00)
     out = a;
     else if (s==2'b10)
     out =c;
     else if (s==2'b01)
     out = b;
     else
     out = a;     
end
endmodule