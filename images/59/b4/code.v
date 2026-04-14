module top_module(
  input [n-1:0] in,
  input en,
  output [n-1:0] out
);parameter n = 8; // number of input and output signals

reg [n-1:0] latch; // latch to hold previous input values

always @(posedge en) begin
  if (en) begin
    latch <= in; // store input values in latch when enable signal is high
  end
end

assign out = en ? in : latch; // connect inputs to outputs when enable signal is high, otherwise hold previous values

endmodule