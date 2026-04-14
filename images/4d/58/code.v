module top_module(A, Z);input A;
  output Z;
  not (Z, A);
  specify
    (A => Z)=(3, 3);	
  endspecify
endmodule