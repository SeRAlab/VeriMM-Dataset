module top_module(
    input [1:0] select,
    input [3:0] operand1,
    input [3:0] operand2,
    output [3:0] result
);wire [7:0] product;
    wire [3:0] sum;

    // Multiplication operation
    assign product = operand1 * operand2;

    // Addition operation
    assign sum = operand1 + operand2;

    // Mux to select operation
    assign result = (select == 2'b00) ? product[3:0] : sum;

endmodule