module reset_synchronizer (
  input async_reset,
  input clk,
  output sync_reset
);

parameter delay = 3; // number of clock cycles for which sync_reset should be low

reg sync_reset_reg;
reg [delay-1:0] delay_chain;

always @(posedge clk) begin
  delay_chain <= {delay_chain[(delay-2):0], async_reset}; // shift in async_reset signal
  sync_reset_reg <= ~(|delay_chain); // sync_reset is low when any bit in delay_chain is high
end

assign sync_reset = sync_reset_reg;

endmodule