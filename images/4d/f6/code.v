module top_module(A, B, Cin, S, Cout);input [3:0] A;
    input [3:0] B;
    input Cin;
    output [3:0] S;  // Change C to S for sum output
    output Cout;     // Declare a separate output for carry out

    wire [3:0] temp1;
    wire [3:0] temp2;

    // Calculate the sum of A and B without considering carry-in
    assign temp1 = A ^ B;

    // Calculate the carry-out from A and B
    assign temp2 = A & B;

    // Calculate the final sum with carry-in
    assign S = temp1 ^ {3'b000, Cin};  // Use take care of the carry in properly

    // Calculate the final carry-out
    assign Cout = (temp1 & {3'b000, Cin}) | temp2[3];  // Use Cout for the final output
endmodule