module top_module(
  input clk,
  input pwr,
  output reg rst
);parameter rst_time = 10; // duration for which the reset signal should be asserted

reg pwr_prev; // previous value of power signal
reg [3:0] rst_count; // counter for reset signal duration

always @(posedge clk) begin
  if (pwr && !pwr_prev) begin // power has just been applied
    rst <= 1;
    rst_count <= 0;
  end else if (rst_count < rst_time) begin // reset signal is still being asserted
    rst <= 1;
    rst_count <= rst_count + 1;
  end else begin // reset signal has been de-asserted
    rst <= 0;
  end
  
  pwr_prev <= pwr;
end

endmodule