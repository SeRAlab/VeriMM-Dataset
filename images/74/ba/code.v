module top_module(
  input trig, // trigger signal
  input rst, // reset signal
  input clk, // system clock
  output reg out // output pulse
);parameter w = 10; // width of the output pulse in clock cycles
parameter r1 = 1000; // resistance of the first external resistor
parameter r2 = 1000; // resistance of the second external resistor
parameter c = 1e-6; // capacitance of the capacitor

reg [31:0] count; // counter for pulse width

// Removed unused real t calculation
// always @(*) begin
//   t = 0.69 * (r1 + r2) * c; // calculate pulse duration
// end

always @(posedge clk or posedge rst) begin
  if (rst) begin
    out <= 0; // reset output pulse
    count <= 0; // reset pulse width counter
  end else if (trig) begin
    out <= 1; // start output pulse
    count <= 0; // reset pulse width counter
  end else if (out) begin
    count <= count + 1; // increment pulse width counter
    if (count >= w) begin
      out <= 0; // end output pulse
    end
  end
end

endmodule