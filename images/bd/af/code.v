module top_module(
    input signed [3:0] a,
    input signed [3:0] b,
    input signed cin,
    output signed [3:0] sum,
    output signed cout
  );assign {cout, sum} = a + b + cin;
  
endmodule