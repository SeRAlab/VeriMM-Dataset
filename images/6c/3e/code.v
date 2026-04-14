module top_module(
    input [3:0] D,
    input [1:0] S,
    output Y
);wire buf0, buf1, buf2;

    // Using simple wire assignments instead of unknown buf modules
    assign buf0 = D[0];
    assign buf1 = D[1];
    assign buf2 = D[2];

    assign Y = (S[1] & S[0]) ? D[3] : (S[1] ? buf2 : (S[0] ? buf1 : buf0));

endmodule