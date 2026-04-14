module vector_addition (
    input [7:0] x1, // x component of first vector
    input [7:0] y1, // y component of first vector
    input [7:0] x2, // x component of second vector
    input [7:0] y2, // y component of second vector
    output [7:0] x_out, // x component of result vector
    output [7:0] y_out  // y component of result vector
);
    assign x_out = x1 + x2;
    assign y_out = y1 + y2;
endmodule