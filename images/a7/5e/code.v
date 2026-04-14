module top_module(
  input [31:0] num1,
  input [31:0] num2,
  input sel,
  output eq,
  output gt,
  output lt
);wire signed [31:0] snum1, snum2;
  assign snum1 = $signed(num1);
  assign snum2 = $signed(num2);

  wire [2:0] unsigned_result, signed_result;

  assign unsigned_result = (num1 == num2) ? 3'b001 : (num1 > num2) ? 3'b010 : 3'b100;
  assign signed_result = (snum1 == snum2) ? 3'b001 : (snum1 > snum2) ? 3'b010 : 3'b100;

  assign {eq, gt, lt} = (sel == 0) ? unsigned_result : signed_result;

endmodule