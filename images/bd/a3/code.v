module top_module(
    A,
    B,
    CI,
    SUM,
    COUT,
    ERROR
);input A;
    input B;
    input CI;
    output SUM;
    output COUT;
    output ERROR;

    wire xor0_out;
    wire xor1_out;
    wire and0_out;
    wire and1_out;
    wire or0_out;

    xor xor0 (xor0_out, A, B);
    xor xor1 (xor1_out, xor0_out, CI);
    and and0 (and0_out, A, B);
    and and1 (and1_out, xor0_out, CI);
    or or0 (or0_out, and0_out, and1_out);

    assign SUM = xor1_out;
    assign COUT = or0_out;
    assign ERROR = (A == 1'bZ || B == 1'bZ || CI == 1'bZ) ? 1 : 0;
endmodule