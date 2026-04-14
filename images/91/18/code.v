module top_module(
  input [n-1:0] num1,
  input [n-1:0] num2,
  input cmp_mode,
  output gt,
  output eq,
  output lt
);parameter n = 8; // number of bits in input numbers

reg signed [n-1:0] signed_num1;
reg signed [n-1:0] signed_num2;
reg [n-1:0] unsigned_num1;
reg [n-1:0] unsigned_num2;

assign gt = (cmp_mode == 0) ? (unsigned_num1 > unsigned_num2) : (signed_num1 > signed_num2);
assign eq = (cmp_mode == 0) ? (unsigned_num1 == unsigned_num2) : (signed_num1 == signed_num2);
assign lt = (cmp_mode == 0) ? (unsigned_num1 < unsigned_num2) : (signed_num1 < signed_num2);

always @(*) begin
  if (cmp_mode == 0) begin // unsigned comparison
    unsigned_num1 = num1;
    unsigned_num2 = num2;
    signed_num1 = {1'b0, num1};
    signed_num2 = {1'b0, num2};
  end else begin // signed comparison
    unsigned_num1 = num1;
    unsigned_num2 = num2;
    signed_num1 = num1;
    signed_num2 = num2;
  end
end

endmodule