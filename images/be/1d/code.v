module top_module(Y, A, B, sel);output [15:0] Y;
     input  [15:0] A, B;
     input  sel;
     reg    [15:0] Y;
     always @(A or B or sel) 
       if (sel == 1'b0) 
         Y = A;
       else 
         Y = B;
  endmodule