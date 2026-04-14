module top_module(output reg Q,
   input wire D,
   input wire CLK,
   input wire RST
   );always @(posedge CLK or posedge RST)
     if (RST)
       Q <= 0;
     else
       Q <= D;

endmodule