module top_module(
  input CLK, EN, TE,
  output reg ENCLK
);always @(*) begin
    if (EN) 
      ENCLK = CLK;
    else 
      ENCLK = 1'b0;
  end

endmodule