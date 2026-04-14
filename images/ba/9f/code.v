module top_module(
    input  wire a,
    input  wire b,
    input  wire s,
    output wire y
);assign y = (s) ? b : a;
endmodule