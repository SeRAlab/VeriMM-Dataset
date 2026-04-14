module top_module(
  input A,
  input B,
  input C,
  input D,
  input E,
  input F,
  input G,
  input H,
  input I,
  output Y
);wire cond1, cond2, cond3, cond4, cond5;

  // Condition 1: At least 3 of the inputs are high
  assign cond1 = (A + B + C + D + E + F + G + H + I) >= 3;

  // Condition 2: A, B, and C are either all high or all low
  assign cond2 = ((A & B & C) | (!A & !B & !C));

  // Condition 3: D, E, and F are either all high or all low
  assign cond3 = ((D & E & F) | (!D & !E & !F));

  // Condition 4: G and H are both low
  assign cond4 = (!G & !H);

  // Condition 5: I is high
  assign cond5 = I;

  // Output Y is 1 if all conditions are met, otherwise 0
  assign Y = (cond1 & cond2 & cond3 & cond4 & cond5);

endmodule