module top_module(
  input trigger,
  input clk,
  output reg pulse
);parameter t = 10; // duration of the output pulse in clock cycles.

reg [31:0] counter = 0; // counter to keep track of pulse duration

always @(posedge clk) begin
  if (trigger && !pulse) begin // generate pulse on trigger
    pulse <= 1;
    counter <= 0;
  end else if (counter < t) begin // keep pulse high for t cycles
    pulse <= 1;
    counter <= counter + 1;
  end else begin // reset pulse after t cycles
    pulse <= 0;
  end
end

endmodule