module add_sub(
  input [3:0] A,
  input [3:0] B,
  input SUB,
  output reg [3:0] RESULT
);

  always @(*) begin
    if (SUB == 0) begin
      RESULT = A + B;
    end else begin
      RESULT = A - B;
    end
  end

endmodule