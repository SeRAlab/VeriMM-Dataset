module top_module(
  input in,
  output reg out
);always @(*) begin
    if (in == 1'b1)
      out = 1'b1;
    else
      out = 1'b0;
  end

endmodule