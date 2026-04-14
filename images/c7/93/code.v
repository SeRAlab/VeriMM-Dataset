module and_combination (
  input a,
  input b,
  input c,
  output reg out
);

  // Implementing AND gates to generate the output
  always @(*)
    begin
      if(a && b && c)
        out = 1;
      else
        out = 0;
    end

endmodule
