module top_module(
  input [31:0] operand1,
  input [31:0] operand2,
  input [1:0] sel,
  output [31:0] result
);// Extracting sign, exponent, and mantissa of operand1
  wire sign1 = operand1[31];
  wire [7:0] exp1 = operand1[30:23];
  wire [22:0] mant1 = operand1[22:0];

  // Extracting sign, exponent, and mantissa of operand2
  wire sign2 = operand2[31];
  wire [7:0] exp2 = operand2[30:23];
  wire [22:0] mant2 = operand2[22:0];

  // Initializing variables for result calculation
  wire [24:0] mant_res;
  wire [8:0] exp_res;
  wire sign_res;

  // Addition operation
  wire [24:0] mant_add;
  wire [8:0] exp_add;
  wire sign_add;
  assign {sign_add, exp_add, mant_add} = (sign1 == sign2) ? {sign1, exp1, mant1} + {1'b0, exp2, mant2} : {sign1, exp1, mant1} - {1'b0, exp2, mant2};

  // Subtraction operation
  wire [24:0] mant_sub;
  wire [8:0] exp_sub;
  wire sign_sub;
  assign {sign_sub, exp_sub, mant_sub} = (sign1 == sign2) ? {sign1, exp1, mant1} - {1'b0, exp2, mant2} : {sign1, exp1, mant1} + {1'b0, exp2, mant2};

  // Multiplication operation
  wire [24:0] mant_mul;
  wire [8:0] exp_mul;
  wire sign_mul;
  assign {sign_mul, exp_mul, mant_mul} = {sign1 ^ sign2, exp1 + exp2 - 127'h7f, mant1 * mant2};

  // Division operation
  wire [24:0] mant_div;
  wire [8:0] exp_div;
  wire sign_div;
  assign {sign_div, exp_div, mant_div} = {sign1 ^ sign2, exp1 - exp2 + 127'h7f, mant1 / mant2};

  // Rounding the result to the nearest representable floating-point number
  wire [24:0] mant_round;
  wire [8:0] exp_round;
  wire sign_round;
  assign {sign_round, exp_round, mant_round} = (sel == 2'b00) ? {sign_add, exp_add, mant_add} :
                                               (sel == 2'b01) ? {sign_sub, exp_sub, mant_sub} :
                                               (sel == 2'b10) ? {sign_mul, exp_mul, mant_mul} :
                                                                 {sign_div, exp_div, mant_div};
  assign result = {sign_round, exp_round, mant_round};

endmodule