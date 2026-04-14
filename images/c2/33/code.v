module flip_flop (
  input clk,
  input ar,
  input s,
  input d,
  output reg q
);

  always @(negedge clk or posedge ar) begin
    if (ar) begin
      q <= 1'b0;
    end else begin
      if (s) begin
        q <= 1'b1;
      end else begin
        q <= d;
      end
    end
  end

endmodule
