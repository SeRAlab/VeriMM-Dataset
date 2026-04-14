module top_module(
 input wire [3:0] A,
 input wire [3:0] B,
 output wire [7:0] Result
);// Declare intermediate wires for the results of multiplication
wire [7:0] product;

assign product = A * B; // Using a simple multiplication assignment

assign Result = product; // Assign the result to output

endmodule