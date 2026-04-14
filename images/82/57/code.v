module top_module(
  input [n-1:0] data_in,
  output reg [7:0] checksum_out,
  output reg valid_out
);parameter n = 4; // number of data signals

integer i;
reg [7:0] sum;
reg [7:0] check;

always @(*) begin
  sum = 0;
  for (i = 0; i < n; i = i + 1) begin
    sum = sum + data_in[i];
  end
  checksum_out = sum % 256;
  
  check = sum + checksum_out;
  if (check == 8'hFF) begin
    valid_out = 1;
  end else begin
    valid_out = 0;
  end
end

endmodule