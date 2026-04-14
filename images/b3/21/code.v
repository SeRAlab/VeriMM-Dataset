module top_module(
  input x,
  input y,
  input z,
  output reg Q
);always @* begin
    if (x == 1 && y == 0)
      Q = 1;
    else if (x == 0 && y == 1)
      Q = 1;
    else if (x == 1 && y == 1 && z == 1)
      Q = 1;
    else
      Q = 0;
  end

endmodule