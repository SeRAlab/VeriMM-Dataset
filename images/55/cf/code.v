module top_module(
    output sum,
    output carryout,
    input a,
    input b,
    input carryin
);assign {carryout, sum}=a+b+carryin;endmodule