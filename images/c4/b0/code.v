module omsp_clock_gate (
  input clk,           // Clock
  input enable,        // Clock enable
  input scan_enable,   // Scan enable (active during scan shifting)
  output gclk          // Gated clock
);

  wire enable_in = (enable | scan_enable);

  reg enable_latch;

  always @(posedge clk or posedge enable_in) begin
    if(enable_in) begin
      enable_latch <= enable;
    end
  end

  assign gclk = enable_latch & clk;

endmodule