module top_module(
  input CLK,
  input EN,
  input TE,
  output reg ENCLK
);always @ (posedge CLK) begin
    if (EN && !TE) begin
      ENCLK <= 1'b1;
    end else begin
      ENCLK <= 1'b0;
    end
  end

endmodule