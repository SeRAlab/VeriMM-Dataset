module top_module(
  input [n-1:0] bin,
  output [m-1:0] bcd
);parameter n = 8; // number of bits in the binary number
parameter m = 3; // number of digits in the BCD number

reg [3:0] bcd_digit [0:m-1];
reg [3:0] decimal_num;
integer i;

always @(*) begin
  decimal_num = 0;
  for (i = 0; i < n; i = i + 1) begin
    decimal_num = decimal_num + (bin[i] * (2 ** i));
  end
  
  for (i = 0; i < m; i = i + 1) begin
    bcd_digit[i] = decimal_num % 10;
    decimal_num = decimal_num / 10;
  end
end

assign bcd = {bcd_digit[m-1], bcd_digit[m-2], bcd_digit[m-3]};

endmodule