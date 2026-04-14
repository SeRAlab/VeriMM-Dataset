module top_module(
  input [n-1:0] data,
  output [m-1:0] chksum
);parameter n = 8; // number of data words
parameter m = 16; // number of bits in each data word

reg [m-1:0] sum; // register to hold the sum of the data words
integer i; // Declare the loop variable

// compute the sum of the data words
always @ (data) begin
  sum = 0;
  for (i = 0; i < n; i = i + 1) begin
    sum = sum + data[i];
  end
end

// compute the checksum by taking the sum modulo 2^m
assign chksum = sum % (1 << m);

endmodule