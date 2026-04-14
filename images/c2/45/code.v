module greater_than_or_equal(a, b, y);
  input [7:0] a;
  input [7:0] b;
  output y;
  
  always @(*) begin
    if (a >= b) begin
      y = 1;
    end else begin
      y = 0;
    end
  end
endmodule