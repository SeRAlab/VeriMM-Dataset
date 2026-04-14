module half_subtractor (
  input A,
  input B,
  output D,
  output Bout
);
  assign D = A ^ B;
  assign Bout = ~A & B;
endmodule

module full_subtractor (
  input A,
  input B,
  input Bin,
  output D,
  output Bout
);
  wire half_sub1_D, half_sub1_Bout, half_sub2_D, half_sub2_Bout;
  
  half_subtractor half_sub1 (
    .A(A),
    .B(B),
    .D(half_sub1_D),
    .Bout(half_sub1_Bout)
  );
  
  half_subtractor half_sub2 (
    .A(half_sub1_D),
    .B(Bin),
    .D(half_sub2_D),
    .Bout(half_sub2_Bout)
  );
  
  assign D = half_sub2_D;
  assign Bout = half_sub1_Bout | half_sub2_Bout;
endmodule