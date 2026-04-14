module top_module(input A, input B, output Q);xor   (Q,B,A);

   specify
      (A => Q) = (1,1);
      (B => Q) = (1,1);
   endspecify

endmodule