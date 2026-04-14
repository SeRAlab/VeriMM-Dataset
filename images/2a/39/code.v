module linear_regression(
    input [7:0] x1,
    input [7:0] x2,
    output [15:0] y
);
    // Parameters for the linear regression
    parameter integer a = 2;
    parameter integer b = 3;
    parameter integer c = 5;

    // Calculate y = a*x1 + b*x2 + c
    assign y = (a * x1) + (b * x2) + c;

endmodule