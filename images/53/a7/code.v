module top_module(
  input in1,
  input in2,
  input sel,
  output reg out
);always @(*) begin
  if (sel == 0) begin
    out = in1;
  end else begin
    out = in2;
  end
end

endmodule