module top_module(
    input A,
    input B,
    output X
);// Define and instantiate a basic logical AND operation
    wire and_output;

    assign and_output = A & B;
    
    // Drive the output X with the AND operation result
    assign X = and_output;

endmodule