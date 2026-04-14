module my_full_adder (
    input A,
    input B,
    input CIN,
    output SUM,
    output COUT
);

    wire w1, w2, w3;
    
    assign w1 = A ^ B;
    assign w2 = CIN ^ w1;
    assign SUM = w1 ^ CIN;
    assign COUT = w2;
    
endmodule