module top_module(
  input pwr,
  input clk,      // Added clk input signal
  output reg rst  // Changed rst to reg to allow assignment
);parameter t = 100; // time in nanoseconds to assert the reset signal

reg [31:0] count; // 32-bit counter to count clock cycles

always @(posedge clk) begin
  if (pwr) begin
    count <= 0;  // reset counter when pwr goes high
    rst <= 0;    // assert reset signal
  end
  else if (count < (t/10)) begin // divide by 10 to convert to clock cycles
    count <= count + 1; // increment counter
    rst <= 0; // keep reset signal low
  end
  else begin
    rst <= 1; // deassert reset signal
  end
end

endmodule