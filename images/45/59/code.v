module binary_adder(
    input wire [3:0] a,
    input wire [3:0] b,
    output wire [4:0] sum
    );

assign sum = a + b;

endmodule