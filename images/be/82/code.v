module top_module(
  input [n-1:0] data_in,
  input valid_in,
  input reset,
  output reg [15:0] checksum_16,
  output reg [31:0] checksum_32,
  output reg valid_out
);parameter n = 8; // size of data_in in bits

reg [15:0] sum1;
reg [15:0] sum2;
reg [31:0] sum3;
reg [31:0] sum4;

always @(posedge valid_in or posedge reset) begin
  if (reset) begin
    sum1 <= 0;
    sum2 <= 0;
    sum3 <= 0;
    sum4 <= 0;
    valid_out <= 0;
  end else if (valid_in) begin
    sum1 <= sum1 + data_in;
    sum2 <= sum2 + sum1;
    sum3 <= sum3 + data_in;
    sum4 <= sum4 + sum3;
  end else begin
    checksum_16 <= ~(sum2 + sum1);
    checksum_32 <= ~(sum4 + sum3);
    valid_out <= 1;
  end
end

endmodule