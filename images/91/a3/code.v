module top_module(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);wire [3:0] xor_out;
    wire [3:0] and_out;
    wire [3:0] add_out;

    assign xor_out = a ^ b;
    assign and_out = a & b;
    assign add_out = xor_out ^ cin;

    assign sum = add_out;
    assign cout = and_out | (xor_out & cin);

endmodule