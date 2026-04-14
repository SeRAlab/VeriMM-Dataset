module top_module(
  input clk,
  input pwr_on,
  output reg rst
);parameter reset_time = 100; // length of time for reset signal to be active

reg reset_pulse; // pulse signal used to generate reset signal

always @(posedge clk) begin
  if (pwr_on) begin
    reset_pulse <= 1'b1;
    rst <= 1'b1;
  end else if (reset_pulse) begin
    reset_pulse <= 1'b0;
    rst <= 1'b0;
  end
end

always @(posedge clk) begin
  if (reset_pulse) begin
    #reset_time;
    reset_pulse <= 1'b0;
  end
end

endmodule