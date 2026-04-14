module top_module(
  input in0,
  input in1,
  input in2,
  input in3,
  input sel0,
  input sel1,
  output reg out
);always @(*) begin
  if (sel0 == 0 && sel1 == 0) begin
    out = in0;
  end else if (sel0 == 1 && sel1 == 0) begin
    out = in1;
  end else if (sel0 == 0 && sel1 == 1) begin
    out = in2;
  end else if (sel0 == 1 && sel1 == 1) begin
    out = in3;
  end
end

endmodule