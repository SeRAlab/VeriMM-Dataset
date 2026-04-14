module top_module(
  (* abc9_carry *)
  output [3:0] CO,
  output [3:0] O,
  (* abc9_carry *)
  input        CI,
  input        CYINIT,
  input  [3:0] DI, S
);assign O = S ^ {CO[2:0], CI | CYINIT};
  assign CO[0] = S[0] ? CI | CYINIT : DI[0];
  assign CO[1] = S[1] ? CO[0] : DI[1];
  assign CO[2] = S[2] ? CO[1] : DI[2];
  assign CO[3] = S[3] ? CO[2] : DI[3];
  specify
    
    (CYINIT => O[0]) = 482;
    (S[0]   => O[0]) = 223;
    (CI     => O[0]) = 222;
    (CYINIT => O[1]) = 598;
    (DI[0]  => O[1]) = 407;
    (S[0]   => O[1]) = 400;
    (S[1]   => O[1]) = 205;
    (CI     => O[1]) = 334;
    (CYINIT => O[2]) = 584;
    (DI[0]  => O[2]) = 556;
    (DI[1]  => O[2]) = 537;
    (S[0]   => O[2]) = 523;
    (S[1]   => O[2]) = 558;
    (S[2]   => O[2]) = 226;
    (CI     => O[2]) = 239;
    (CYINIT => O[3]) = 642;
    (DI[0]  => O[3]) = 615;
    (DI[1]  => O[3]) = 596;
    (DI[2]  => O[3]) = 438;
    (S[0]   => O[3]) = 582;
    (S[1]   => O[3]) = 618;
    (S[2]   => O[3]) = 330;
    (S[3]   => O[3]) = 227;
    (CI     => O[3]) = 313;
    (CYINIT => CO[0]) = 536;
    (DI[0]  => CO[0]) = 379;
    (S[0]   => CO[0]) = 340;
    (CI     => CO[0]) = 271;
    (CYINIT => CO[1]) = 494;
    (DI[0]  => CO[1]) = 465;
    (DI[1]  => CO[1]) = 445;
    (S[0]   => CO[1]) = 433;
    (S[1]   => CO[1]) = 469;
    (CI     => CO[1]) = 157;
    (CYINIT => CO[2]) = 592;
    (DI[0]  => CO[2]) = 540;
    (DI[1]  => CO[2]) = 520;
    (DI[2]  => CO[2]) = 356;
    (S[0]   => CO[2]) = 512;
    (S[1]   => CO[2]) = 548;
    (S[2]   => CO[2]) = 292;
    (CI     => CO[2]) = 228;
    (CYINIT => CO[3]) = 580;
    (DI[0]  => CO[3]) = 526;
    (DI[1]  => CO[3]) = 507;
    (DI[2]  => CO[3]) = 398;
    (DI[3]  => CO[3]) = 385;
    (S[0]   => CO[3]) = 508;
    (S[1]   => CO[3]) = 528;
    (S[2]   => CO[3]) = 378;
    (S[3]   => CO[3]) = 380;
    (CI     => CO[3]) = 114;
  endspecify
endmodule