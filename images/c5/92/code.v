module comparator_4bit (
  input [3:0] A,
  input [3:0] B,
  output reg EQ
);

  always @(*) begin
    if (A == B) begin
      EQ = 1;
    end else begin
      EQ = 0;
    end
  end

endmodule
