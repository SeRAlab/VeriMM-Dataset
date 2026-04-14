module top_module(
    input A, 
    input B, 
    input Cin, 
    output S, 
    output Cout
);wire w1, w2, w3;
    
    assign w1 = A ^ B;
    assign S = w1 ^ Cin;
    assign w2 = A & B;
    assign w3 = Cin & w1;
    assign Cout = w2 | w3;

endmodule