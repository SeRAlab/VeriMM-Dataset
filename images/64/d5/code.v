module top_module(
  input [n-1:0] in,
  output out
);parameter n = 8; // number of input signals

reg [n-1:0] in_reg;
reg parity;

integer i;
always @(*) begin
  in_reg = in;
  parity = 1'b0;
  for (i = 0; i < n; i = i + 1) begin
    parity = parity ^ in_reg[i];
  end
end

assign out = ~parity;

endmodule