module top_module(
  input CLK,
  input EN,
  input TE,
  input RESET,
  output reg ENCLK
);always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
      ENCLK <= 1'b0;
    end else if (TE) begin
      ENCLK <= 1'b1;
    end else if (EN) begin
      ENCLK <= CLK;
    end else begin
      ENCLK <= 1'b0;
    end
  end

endmodule