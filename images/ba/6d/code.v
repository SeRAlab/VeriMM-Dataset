module top_module(
    input wire x,
    input wire y,
    input wire z,
    output wire answer
);assign answer = (x&y&~z)|(x&y&z);
endmodule