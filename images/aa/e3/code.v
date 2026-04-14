module top_module(
  input a,
  input b,
  input c,
  output reg out
);always @ (a or b or c)
  begin
    if ((a & b & ~c) || (a & ~b & c) || (~a & b & c))
      out = 1;
    else
      out = 0;
  end

endmodule