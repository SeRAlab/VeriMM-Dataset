module top_module(
  input clk,        // Added the clk input signal
  input pulse1,
  input pulse2,
  output reg [7:0] tdc_out
);parameter fs = 100000000; // sampling frequency of the circuit
parameter dt = 10; // conversion time of the TDC in nanoseconds

reg [31:0] timer;
reg pulse1_detected;
reg pulse2_detected;

always @(posedge pulse1) begin
  pulse1_detected <= 1;
  timer <= 0;
end

always @(posedge pulse2) begin
  pulse2_detected <= 1;
  tdc_out <= timer / (fs * dt);
end

always @(posedge clk) begin
  if (pulse1_detected) begin
    timer <= timer + 1;
  end
  if (pulse2_detected) begin
    pulse1_detected <= 0;
    pulse2_detected <= 0;
  end
end

endmodule