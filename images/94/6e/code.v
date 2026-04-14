module top_module(CLK, EN, TE, ENCLK);input CLK, EN, TE;
  output reg ENCLK;

  always @(posedge CLK) begin
    if (EN && ~TE) begin
      ENCLK <= 1'b1; // Enable clock
    end else begin
      ENCLK <= 1'b0; // Disable clock
    end
  end
endmodule