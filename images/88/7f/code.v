module top_module(
  input CLK,
  input EN,
  input TE,
  output reg ENCLK
);always @(posedge CLK) begin
    if (TE) begin
      // Test enable, always pass through clock signal
      ENCLK <= 1'b1;
    end else begin
      // Normal operation
      if (EN) begin
        // Enable signal is high, pass through clock signal
        ENCLK <= 1'b1;
      end else begin
        // Enable signal is low, hold output low
        ENCLK <= 1'b0;
      end
    end
  end

endmodule