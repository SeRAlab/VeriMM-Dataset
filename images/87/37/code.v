module top_module(
  input [7:0] A,
  input [7:0] B,
  input [7:0] C,
  output X
);wire [7:0] smallest;
  wire [7:0] middle;
  wire [7:0] largest;

  assign smallest = (A < B) ? ((A < C) ? A : C) : ((B < C) ? B : C);
  assign largest  = (A > B) ? ((A > C) ? A : C) : ((B > C) ? B : C);
  assign middle   = A + B + C - smallest - largest;

  assign X = (smallest + middle > largest) ? 1 : 0;

endmodule