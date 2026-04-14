module top_module(
  input [n-1:0] ctl,
  output voltage
);parameter n = 3; // number of control signals
parameter r = 100; // maximum resistance value in ohms

reg [7:0] resistance; // 8-bit resolution
reg [n-1:0] ctl_scaled; // scaled control signals

assign voltage = (r * resistance) / 256; // compute voltage output

always @(*) begin
  ctl_scaled = ctl * (256 / (2**n - 1)); // scale control signals
  resistance = ctl_scaled * (r / 255); // compute resistance value
end

endmodule