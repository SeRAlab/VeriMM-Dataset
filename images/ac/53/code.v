module top_module(
    output reg q,      // Declare q as reg since it's assigned in always blocks
    input d, clk, clrn, prn, ena,
    input asdata, aload, sclr, sload
);always @(posedge clk) begin
    if (ena)
      q <= d;
    if (aload)
      q <= d;
    if (sclr)
      q <= 0;
    if (sload)
      q <= d;
  end

  always @* begin
    if (clrn)
      q <= 0;
    else if (prn)
      q <= 1;
    else if (asdata)
      q <= d;
  end

endmodule