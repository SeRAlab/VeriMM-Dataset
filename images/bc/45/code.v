module top_module(
  input clk,        // Added clk input
  input in,
  output reg out    // Changed out to reg type
);parameter clk_period = 10; // clock period in ns
parameter debounce_time = 50; // debounce time in ns

reg in_sync;
reg [31:0] stable_time;
reg [31:0] debounce_count;

always @(posedge clk) begin
  in_sync <= in;
  if (in_sync == out) begin
    stable_time <= stable_time + clk_period;
  end else begin
    stable_time <= 0;
  end
  if (stable_time >= debounce_time) begin
    debounce_count <= debounce_count + 1;
  end else begin
    debounce_count <= 0;
  end
  if (debounce_count >= 2) begin
    out <= in_sync;
  end
end

endmodule