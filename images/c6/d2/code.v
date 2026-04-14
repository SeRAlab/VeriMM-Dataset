module dff_asynch_reset (
  input D,
  input RESET,
  input CLK,
  output reg Q
);

  always @(posedge CLK or negedge RESET) begin
    if (!RESET) begin
      Q <= 0;
    end else begin
      Q <= D;
    end
  end

endmodule