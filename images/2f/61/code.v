module polynomial_evaluator (
    input [3:0] a0,    // Coefficient a0
    input [3:0] a1,    // Coefficient a1
    input [3:0] a2,    // Coefficient a2
    input [3:0] a3,    // Coefficient a3
    input [3:0] x,     // Input value x
    output [7:0] P     // Output of polynomial P(x)
);
    wire [7:0] x_squared;
    wire [7:0] x_cubed;
    
    assign x_squared = x * x;                  // x^2
    assign x_cubed = x_squared * x;            // x^3
    
    assign P = a0 + a1 * x + a2 * x_squared + a3 * x_cubed; // P(x) calculation
endmodule