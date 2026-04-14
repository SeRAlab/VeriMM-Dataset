module adder_4bit(
    input wire [3:0] a,
    input wire [3:0] b,
    output wire [3:0] sum,
    output wire carry_out
);

assign {carry_out, sum} = a + b;

endmodule