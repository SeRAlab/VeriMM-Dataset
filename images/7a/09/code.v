module top_module(
  input CLK,
  input EN,
  input TE,
  output reg ENCLK
);always @ (posedge CLK) begin
    if (EN) begin
      ENCLK <= CLK;
    end
    else begin
      ENCLK <= 1'b0;
    end
  end

endmodule