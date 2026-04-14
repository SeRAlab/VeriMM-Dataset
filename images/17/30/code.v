module majority_voter (
    input wire a,
    input wire b,
    input wire c,
    output wire out
);

assign out = (a & b) | (b & c) | (c & a);

endmodule