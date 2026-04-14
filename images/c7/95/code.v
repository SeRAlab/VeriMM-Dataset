module adder_4_2 (
    input [3:0] A,
    output [1:0] Y
);

    wire [2:0] sum;
    wire [1:0] constant = 2'b10;

    assign sum = A + constant;
    assign Y = (sum > 3) ? 2'b11 : sum[1:0];

endmodule