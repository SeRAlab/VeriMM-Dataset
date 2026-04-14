module top_module(sum, carryout, a, b, carryin);output sum, carryout;
  input a, b, carryin;
  assign {carryout, sum}=a+b+carryin;endmodule