module current_source_sink (
  input V,
  input signed [31:0] Iset,
  input enable,
  output reg signed [31:0] I
);

  always @(*) begin
    if (enable) begin
      if (Iset > 0) begin
        I <= Iset;
      end else begin
        I <= -Iset;
      end
    end else begin
      I <= 0;
    end
  end

endmodule