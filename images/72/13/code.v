module top_module(
  input signal_in,
  output signal_out
);parameter t = 10; // debounce time in milliseconds

reg [31:0] counter;
reg signal_out_reg;
wire signal_in_sync;

assign signal_in_sync = signal_in;

always @(posedge signal_in_sync) begin
  counter <= 0;
end

always @(posedge signal_in_sync) begin
  if (counter < t) begin
    counter <= counter + 1;
    signal_out_reg <= signal_out_reg;
  end else begin
    counter <= 0;
    signal_out_reg <= signal_in_sync;
  end
end

assign signal_out = signal_out_reg;

endmodule