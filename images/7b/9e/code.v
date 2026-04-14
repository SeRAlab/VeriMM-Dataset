module top_module(
  input trigger,
  input clk,           // Add clk as input
  output reg pulse     // Change pulse to reg type
);parameter t = 1; // duration of pulse in seconds

reg pulse_reg;
reg [31:0] count;

always @(posedge trigger) begin
  pulse_reg <= 1;
  count <= t * 100000000; // convert seconds to clock cycles (assuming 100 MHz clock)
end

always @(posedge clk) begin
  if (count > 0) begin
    pulse <= 1;
    count <= count - 1;
  end else begin
    pulse <= 0;
    pulse_reg <= 0;
  end
end

endmodule