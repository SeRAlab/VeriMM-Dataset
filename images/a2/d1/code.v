module top_module(
  input a,
  input b,
  input c,
  output reg out
);always @* begin
    if ({a,b,c} == 3'b111 || {a,b,c} == 3'b110 || {a,b,c} == 3'b101 || {a,b,c} == 3'b011)
      out = 1'b1;
    else
      out = 1'b0;
  end

endmodule