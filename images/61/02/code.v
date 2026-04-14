module top_module(
    input [3:0] A,
    input [3:0] B,
    input CIN,
    output [3:0] SUM,
    output COUT
);wire [3:0] sum;
    wire carry1, carry2, carry3;

    // Use a behavioral description for the full adder if the specific module is not found
    assign {COUT, sum} = A + B + CIN; // Simple 4-bit addition for the full adder

    assign SUM = sum;

endmodule