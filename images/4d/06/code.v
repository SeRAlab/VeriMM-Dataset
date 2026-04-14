module top_module(
  output reg clk,
  output reg en
);parameter freq = 1000000; // frequency of crystal oscillator in Hz
parameter duty_cycle = 0.5; // duty cycle of clock signal (0 to 1)

reg [31:0] counter = 0; // counter to keep track of clock cycles
reg toggle = 0; // toggles between 0 and 1 to generate clock signal

assign clk = toggle; // assign toggle signal to clk output

always @ (posedge clk) begin
  counter <= counter + 1; // increment counter on every clock cycle
  if (counter == (freq / 2) - 1) begin // toggle signal after half of the clock cycles
    toggle <= ~toggle;
    counter <= 0; // reset counter
  end
end

always @ (posedge clk) begin
  if (toggle == 1) begin // enable signal is high when clock signal is high
    en <= 1;
  end else begin
    en <= 0;
  end
end

endmodule