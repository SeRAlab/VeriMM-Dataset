module top_module(
  input [n-1:0] ts,
  output touch
);parameter n = 4; // number of touch sensor signals
parameter threshold = 50; // touch threshold value (0-100)

reg [n-1:0] ts_above_threshold;

always @(*) begin
  ts_above_threshold = (ts >= threshold);
end

assign touch = (|ts_above_threshold);

endmodule