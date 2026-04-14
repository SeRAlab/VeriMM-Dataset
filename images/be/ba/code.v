module top_module(S, Cout, A, B, Cin);// INPUT PORTS
    input [3:0] A;
    input [3:0] B;
    input Cin;

    // OUTPUT PORTS
    output [3:0] S;
    output Cout;

    // INTERNAL VARIABLES
    wire [3:0] sum;
    wire carry;

    // ADDER LOGIC
    assign sum = A + B + Cin;
    assign Cout = (sum > 4'hF) ? 1 : 0;
    assign S = sum[3:0];

endmodule