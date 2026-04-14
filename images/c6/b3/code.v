module same_input (
  input A,
  input B,
  input C,
  output reg out
);

  always @(*) begin
    if (A == B && B == C) begin
      out = 1;
    end else begin
      out = 0;
    end
  end

endmodule
