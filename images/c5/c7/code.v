module logic_function(
  input A,
  input B,
  input C,
  output Y1,
  output Y2,
  output Y3
);

  assign Y1 = (C == 0) ? A : 0;
  assign Y2 = (C == 0) ? B : 0;
  assign Y3 = (C == 1) ? B : 0;

endmodule