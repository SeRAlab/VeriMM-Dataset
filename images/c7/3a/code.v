module comparator_3bit (
  input [2:0] A,
  input [2:0] B,
  input [2:0] C,
  output reg z
);

  always @* begin
    if (A >= B && A <= C) begin
      z = 1;
    end else begin
      z = 0;
    end
  end

endmodule
