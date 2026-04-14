module top_module(
  input sel1,
  input sel2,
  input d0,
  input d1,
  input d2,
  input d3,
  output reg out
);always @(*) begin
    case ({sel1, sel2})
      2'b00: out = d0;
      2'b01: out = d1;
      2'b10: out = d2;
      2'b11: out = d3;
    endcase
  end

endmodule