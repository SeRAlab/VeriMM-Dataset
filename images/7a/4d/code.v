module top_module(
  input [n-1:0] data_in,
  output reg [m-1:0] checksum_out
);parameter n = 8; // number of data signals
parameter m = 8; // width of the checksum value

// Compute the checksum
reg [m-1:0] sum;
integer i;
always @(*) begin
  sum = 0;
  for (i = 0; i < n; i = i + 1) begin
    sum = sum + data_in[i];
  end
  checksum_out = sum % (1 << m);
end

// Check the checksum
reg [m-1:0] sum_check;
always @(*) begin
  sum_check = 0;
  for (i = 0; i < n; i = i + 1) begin
    sum_check = sum_check + data_in[i];
  end
  sum_check = sum_check + checksum_out;
  if (sum_check == (1 << m) - 1) begin
    $display("Checksum is valid");
  end else begin
    $display("Checksum is invalid");
  end
end

endmodule