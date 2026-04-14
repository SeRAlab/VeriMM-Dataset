module adder16bit(a, b, sum);
    input [15:0] a;
    input [15:0] b;
    output [15:0] sum;

    assign sum = a + b;
endmodule