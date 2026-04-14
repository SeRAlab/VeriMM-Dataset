module top_module(X, Y, Cin, G, P, Sum);input X;
      input Y;
      input Cin;
      output G;
      output P;
      output Sum;

      wire P_int;

      assign G = X & Y;
      assign P = P_int;
      assign P_int = X ^ Y;
      assign Sum = P_int ^ Cin;endmodule