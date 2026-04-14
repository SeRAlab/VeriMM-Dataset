module top_module(LO,
    O,
    S,
    Addr_2,
    CI,
    lopt,
    lopt_1);output LO;
  output O;
  input S;
  input Addr_2;
  input CI;
  input lopt;
  input lopt_1;

  wire Addr_2;
  wire CI;
  wire LO;
  wire O;
  wire S;

  assign LO = lopt;
  assign O = lopt_1;endmodule