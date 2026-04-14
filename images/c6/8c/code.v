module comparator(
  input [3:0] A,
  input [3:0] B,
  output reg [3:0] Y
);

  always @(*) begin
    if (A >= B) begin
      Y = A - B;
    end
    else begin
      Y = B - A;
    end
    if (A == B) begin
      Y = 0;
    end
  end

endmodule