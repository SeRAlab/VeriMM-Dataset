module top_module( input D,input cdn, input clk, output reg Q);always @ (posedge clk or negedge cdn) 
       if (!cdn)
          Q <= 0;
       else
          Q <= D;
endmodule