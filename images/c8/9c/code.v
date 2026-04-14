module m1(input [3:0] a, output [3:0] b);

  always @(*) begin
    if (a <= 4) begin
      b = a * 2;
    end else begin
      b = a / 2;
    end
  end

endmodule