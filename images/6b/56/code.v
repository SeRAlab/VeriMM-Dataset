module top_module(
    input A,
    input B,
    input CIN,
    output SUM,
    output COUT
);wire a_xor_b;
    wire b_xor_cin;
    wire a_and_b;
    wire b_and_cin;
    wire a_and_cin;
    wire a_or_b_or_cin;
    
    xor (a_xor_b, A, B);
    xor (b_xor_cin, B, CIN);
    and (a_and_b, A, B);
    and (b_and_cin, B, CIN);
    and (a_and_cin, A, CIN);
    or (a_or_b_or_cin, a_and_b, b_and_cin, a_and_cin);
    
    assign SUM = a_xor_b ^ CIN;
    assign COUT = b_xor_cin | a_or_b_or_cin;

endmodule