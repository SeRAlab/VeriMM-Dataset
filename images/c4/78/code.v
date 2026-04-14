module unsigned_min(
  input [31:0] a, b, c, d,
  output reg [31:0] min
);

  always @(*) begin
    if(a < b && a < c && a < d)
      min = a;
    else if(b < c && b < d)
      min = b;
    else if(c < d)
      min = c;
    else
      min = d;
  end

endmodule
