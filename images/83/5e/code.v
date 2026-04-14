module top_module(
  input [n-1:0] data_in,
  output reg checksum_out,
  output reg error_flag
);parameter n = 8; // number of data bits
parameter m = 16; // predefined value

integer i;
reg [n-1:0] sum;

always @(*) begin
  sum = 0;
  for (i = 0; i < n; i = i + 1) begin
    sum = sum + data_in[i];
  end
  checksum_out = sum % m;
  error_flag = ((sum + checksum_out) % m) != 0;
end

endmodule