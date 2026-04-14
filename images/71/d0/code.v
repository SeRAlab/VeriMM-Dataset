module top_module(
  input [n-1:0] data,
  output reg [31:0] checksum  // Changed to reg to allow assignment in always block
);parameter n = 4; // number of data words

reg [31:0] sum1, sum2;
reg [31:0] data_complement;
integer i;

always @* begin
  sum1 = 0;
  sum2 = 0;
  for (i = 0; i < n; i = i + 1) begin
    data_complement = ~data[i];
    sum1 = sum1 + data[i] + data_complement;
    sum2 = sum2 + sum1;
  end
  checksum = ~(sum1 + sum2);
end

endmodule