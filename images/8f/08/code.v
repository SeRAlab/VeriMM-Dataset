module top_module(X, Y, Cin, Cout, Sum);input X, Y, Cin;
output Cout, Sum;
    assign Sum = X ^ Y ^ Cin;
    assign Cout = (X && Y) || (X && Cin) || (X && Cin);
endmodule