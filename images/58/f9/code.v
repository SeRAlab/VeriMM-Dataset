module top_module(
    input A0,
    input A1,
    input S,
    output Y
);assign Y = (S) ? A1 : A0;
endmodule