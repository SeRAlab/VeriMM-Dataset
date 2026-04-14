module abs_calc (
  input signed [31:0] in,
  output reg [31:0] out
);

  always @(*) begin
    if (in >= 0) begin
      out = in;
    end else begin
      out = ~in + 1;
    end
  end

endmodule