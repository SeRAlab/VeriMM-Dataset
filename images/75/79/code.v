module top_module(input D, input C, output reg Q);always @(posedge C)
     Q <= D;

   specify
      (posedge C => (Q +: D)) = (1,1);
   endspecify

endmodule