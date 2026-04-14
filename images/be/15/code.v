module top_module(
    input [7:0] a, b, c, d, // Input ports for the 4-way minimum circuit
    input [31:0] num1, num2, // Input ports for the 32-bit adder/subtractor
    input sub, // Select input for addition/subtraction
    output [31:0] result // Output port for the final sum
);// 4-way minimum circuit
wire [7:0] min1, min2, min3, min4;
wire [7:0] min12, min34;
wire [7:0] min1234;

assign min1 = (a < b) ? a : b;
assign min2 = (a < b) ? b : a;
assign min3 = (c < d) ? c : d;
assign min4 = (c < d) ? d : c;

assign min12 = (min1 < min3) ? min1 : min3;
assign min34 = (min2 < min4) ? min2 : min4;

assign min1234 = (min12 < min34) ? min12 : min34;

// 32-bit adder/subtractor
wire [31:0] sum;
wire [31:0] diff;

assign sum = num1 + num2;
assign diff = num1 - num2;

assign result = (sub) ? min1234 - diff : min1234 + sum;

endmodule