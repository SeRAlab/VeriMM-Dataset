module top_module(
  input [n-1:0] d,
  output p, e
);parameter n = 8; // number of data bits
parameter parity = "even"; // parity type (even or odd)

reg parity_bit;
wire [n-1:0] ones_count;
wire parity_match;

assign ones_count = {n{1'b0}} + d;
assign parity_match = (parity == "even") ? (ones_count % 2 == 0) : (ones_count % 2 == 1);

always @* begin
  if (parity == "even") begin
    parity_bit = (ones_count % 2 == 0) ? 1'b0 : 1'b1;
  end else begin
    parity_bit = (ones_count % 2 == 1) ? 1'b0 : 1'b1;
  end
end

assign p = parity_bit;
assign e = (parity_match) ? 1'b0 : 1'b1;

endmodule