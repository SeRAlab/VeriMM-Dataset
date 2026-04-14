module top_module( out, cout, a, b, cin );input  a, b, cin;
   output out, cout;

   
   reg out, cout;

   always @ (a or b or cin) begin
      {cout, out} = a + b + cin;
   end
  
endmodule