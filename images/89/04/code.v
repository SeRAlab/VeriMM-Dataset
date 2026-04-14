module top_module(
  input a,
  input b,
  input c,
  input d,
  input sel0,
  input sel1,
  output reg out
);always @(*) begin
    case ({sel1, sel0})
      2'b00: out = a;
      2'b01: out = b;
      2'b10: out = c;
      2'b11: out = d;
    endcase
  end

endmodule