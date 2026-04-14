module top_module(
  output reg out,
  input in0,
  input in1,
  input sel0,
  input sel1
);always @ (sel0 or sel1 or in0 or in1) begin
    case ({sel1, sel0})
      2'b00: out = in0;
      2'b01: out = in1;
      2'b10: out = 1'b0;
      2'b11: out = 1'bx;
    endcase
  end

endmodule