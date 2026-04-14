module always_high_except_specific (
  input [2:0] data,
  output reg out
);

  always @(*) begin
    if (data[2:1] == 2'b11 || data[1:0] == 2'b11) begin
      out <= 1'b0;
    end else begin
      out <= 1'b1;
    end
  end

endmodule
