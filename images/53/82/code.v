module top_module(CLK, EN, TE, ENCLK);input CLK, EN, TE;
  output reg ENCLK;

  always @(posedge CLK) begin
    if (EN) begin
      ENCLK <= TE;
    end
  end

endmodule