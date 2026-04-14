module top_module(clk, reset, S, R, Q);input      clk, reset, S, R;
   output reg Q;
   
   always @ (posedge clk, posedge reset)
      if (reset)
         Q <= 1'b0; else 
      if (S)
         Q <= 1'b1; else
      if (R)
         Q <= 1'b0; else 
         
         Q <= Q;
         
endmodule