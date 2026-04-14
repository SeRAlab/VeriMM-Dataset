module top_module(
  input in,
  output out
);parameter delay = 10; // amount of delay to introduce into the signal

reg [delay-1:0] buffer;

always @(in) begin
  buffer <= {buffer[delay-2:0], in};
end

assign out = buffer[delay-1];

endmodule