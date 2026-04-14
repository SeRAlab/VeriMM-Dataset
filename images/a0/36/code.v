module binary_adder_4bit (
    input wire [3:0] a,
    input wire [3:0] b,
    input wire cin,
    output wire [3:0] sum,
    output wire cout
);

    wire [4:0] full_sum;

    assign full_sum = a + b + cin;
    assign sum = full_sum[3:0];
    assign cout = full_sum[4];

endmodule