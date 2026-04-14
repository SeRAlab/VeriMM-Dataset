module top_module(
  input p1,
  input p2,
  input p3,
  input p4,
  input p5,
  output reg y
);always @(*) begin
    if (p1 || p2 || p3 || p4 || p5) begin
      y <= 0;
    end else begin
      y <= 1;
    end
  end

endmodule