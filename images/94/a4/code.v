module top_module(
  input [n-1:0] data_in,
  output reg parity_out
);parameter n = 8; // number of data bits
parameter parity_type = "even"; // even or odd parity

integer i;
reg [n-1:0] data_bits;
reg parity_bit;

always @(*) begin
  data_bits = data_in;
  parity_bit = data_bits[0];

  for (i = 1; i < n; i = i + 1) begin
    parity_bit = parity_bit ^ data_bits[i];
  end

  if (parity_type == "odd") begin
    parity_out = ~parity_bit;
  end else begin
    parity_out = parity_bit;
  end
end

endmodule