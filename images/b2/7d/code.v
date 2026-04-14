module top_module(a,b);input  a;
   output b;
   reg    b;
   reg    c;
   
   always @(a) begin
      c=a;
      b=c;
   end
   
endmodule