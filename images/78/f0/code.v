module top_module(
  input [n-1:0] data,
  input parityType,
  output reg p
);parameter n = 8; // number of data bits

integer i;
integer count;

always @(*) begin
  count = 0;
  for (i = 0; i < n; i = i + 1) begin
    count = count + data[i];
  end

  if (parityType == 1'b0) begin // even parity
    p = (count % 2 == 1) ? 1'b1 : 1'b0;
  end else begin // odd parity
    p = (count % 2 == 0) ? 1'b1 : 1'b0;
  end
end

endmodule