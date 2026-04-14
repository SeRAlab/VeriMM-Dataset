module top_module( a,b,c, clk, q,q1,q2);input a,b,c,clk;
   output q, q1,q2;
   wire clk;
   reg q, q1,q2;
     	 
   always @ (posedge clk)
   begin
    q <= a;
    q1<=b;
    q2 <= c;
 end

endmodule