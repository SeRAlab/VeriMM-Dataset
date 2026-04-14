module top_module(
  input A1,
  input A2,
  input A3,
  input B1,
  input B2,
  input C1,
  input C2,
  input D1,
  input D2,
  input D3,
  output X
);assign X = (A1 & A2 & A3) | (B1 & B2) | (C1 & C2) | (~D1 & ~D2 & ~D3);

endmodule