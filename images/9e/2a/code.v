module top_module(
  input clock,
  input signal_in,
  output reg signal_out
);parameter debounce_time = 10; // time (in clock cycles) to debounce input signal

reg [debounce_time-1:0] stable_count; // counter to track stable input signal

always @(posedge clock) begin
  if (signal_in == signal_out) begin
    stable_count <= stable_count + 1;
    if (stable_count == debounce_time) begin
      signal_out <= signal_in;
      stable_count <= 0;
    end
  end else begin
    signal_out <= signal_in;
    stable_count <= 0;
  end
end

endmodule