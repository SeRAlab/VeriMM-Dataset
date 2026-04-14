module top_module(
  input signal_in,
  output signal_out
);parameter glitch_duration = 4; // minimum pulse duration

reg [glitch_duration-1:0] delay_line;
reg filtered_signal;

always @(posedge signal_in) begin
  delay_line <= {delay_line[glitch_duration-2:0], signal_in};
  if (delay_line[0] == 1'b1 && delay_line[glitch_duration-1] == 1'b0) begin
    filtered_signal <= delay_line[glitch_duration-2];
  end else begin
    filtered_signal <= signal_in;
  end
end

assign signal_out = filtered_signal;

endmodule