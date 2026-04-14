module top_module(
  input CLK, // clock signal
  input EN, // enable signal
  input TE, // transparent enable signal
  output reg ENCLK // gated clock signal
);always @(posedge CLK) begin
    if (TE) begin
      ENCLK <= CLK;
    end else if (EN) begin
      ENCLK <= CLK;
    end else begin
      ENCLK <= 1'b0;
    end
  end

endmodule