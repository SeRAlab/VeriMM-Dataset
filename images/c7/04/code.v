module mag_comp_comb (
  input [1:0] A,
  input [1:0] B,
  output out
);

  always @* begin
    if (A >= B) begin
      out = 1;
    end
    else begin
      out = 0;
    end
  end

endmodule
