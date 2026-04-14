module top_module(
    input [7:0] a,
    input [7:0] b,
    output [7:0] sum,
    output [7:0] difference,
    output [7:0] product,
    output [7:0] quotient
    );// Calculate sum
    assign sum = a + b;
    
    // Calculate difference
    assign difference = (a > b) ? a - b : b - a;
    
    // Calculate product
    assign product = a * b;
    
    // Calculate quotient
    assign quotient = a / b;

endmodule