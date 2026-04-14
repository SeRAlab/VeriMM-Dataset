module top_module(
  input A,
  input B,
  input select,
  output reg out
);always @(select)
  begin
    if (select == 0)
      out = A;
    else
      out = B;
  end

endmodule