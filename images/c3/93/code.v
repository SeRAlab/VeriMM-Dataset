module ADD32
  (output reg signed [31:0] S,
   input signed [31:0] A,
   input signed [31:0] B,
   input C,    // Clock
   input CE,   // Clock Enable
   input R     // Synchronous Reset
   );
   
   always @(posedge C)
     if(R)
       S <= 32'sd0;
     else if(CE)
       S <= A + B;

endmodule