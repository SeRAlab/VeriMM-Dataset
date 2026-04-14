module diff_module(
  input [3:0] A,
  input [3:0] B,
  input C,
  output reg [4:0] diff
);

  always @(*) begin
    diff = A - B;
    if (C == 1'b1) begin
      diff = ~diff + 1'b1;
    end
  end

endmodule