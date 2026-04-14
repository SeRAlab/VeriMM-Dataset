module majority_voter (
    input wire a,
    input wire b,
    input wire c,
    output wire y
);
    assign y = (a + b + c) > 1 ? 1 : 0;
endmodule