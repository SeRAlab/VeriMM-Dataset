module multiplier (
  input A,
  input B,
  input enable,
  output reg C
);

  always @(A, B, enable) begin
    if (enable == 1'b1) begin
      C <= A * B;
    end
    else begin
      C <= 1'b0;
    end
  end

endmodule