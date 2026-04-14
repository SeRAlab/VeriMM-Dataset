module ClockGating (
  input CLK, EN, TE, RESET,
  output reg ENCLK
);

always @ (posedge CLK, posedge RESET) begin
  if (RESET) begin
    ENCLK <= 0;
  end else if (EN) begin
    if (TE) begin
      ENCLK <= 0;
    end else begin
      ENCLK <= ~CLK;
    end
  end else begin
    ENCLK <= 0;
  end
end

endmodule