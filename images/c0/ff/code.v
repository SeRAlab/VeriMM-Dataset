module port_clocking
  (input         clk,
   input         reset,
   input         gmii_rx_clk,
   output        gmii_rx_reset
   );
  reg 		 rx_sync1, rx_sync2;
  always @(posedge gmii_rx_clk)
    begin
      rx_sync1 <= #1 reset;
      rx_sync2 <= #1 rx_sync1;
    end
  assign gmii_rx_reset = reset | rx_sync2;
endmodule