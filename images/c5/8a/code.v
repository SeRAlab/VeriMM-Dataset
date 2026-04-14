module clock_gate (
  input CLK,
  input EN,
  input TE,
  input D,
  output reg ENCLK
);

  always @(posedge CLK) begin
    if (EN && TE) begin
      ENCLK <= D;
    end
  end

endmodule