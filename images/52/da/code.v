module top_module(
    input A,
    input B,
    output Y
);wire a_not, b_not, ab_and;
    not u1 (a_not, A);
    not u2 (b_not, B);
    and u3 (ab_and, a_not, b_not);
    not u4 (Y, ab_and);

endmodule