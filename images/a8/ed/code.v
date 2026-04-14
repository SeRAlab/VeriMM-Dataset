module top_module(
    input [3:0] A,
    input [3:0] B,
    input dir,
    output [3:0] S
);assign S = (dir == 1) ? {A[0], A[3:1]} : {A[2:0], A[3]};
    assign S = (B == 1) ? {S[1:0], S[3:2]} : S;
    assign S = (B == 2) ? {S[2:0], S[3]} : S;
    assign S = (B == 3) ? {S[0], S[3:1], S[2]} : S;

endmodule