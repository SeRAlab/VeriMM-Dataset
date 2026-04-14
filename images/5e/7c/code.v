module top_module(
  input clock,
  input in,
  output out
);reg [2:0] sreg = 0;

  always @(posedge clock) begin
    sreg <= {sreg[1:0], in};
  end

  assign out = sreg[2];

endmodule