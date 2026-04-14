module top_module(
    input [7:0] a,
    input [7:0] b,
    input select,
    output [7:0] out_xor,
    output [7:0] out_and,
    output [7:0] out_not
);wire [7:0] b_not;
    assign b_not = ~b;

    wire [7:0] xor_result;
    assign xor_result = a ^ b;

    wire [7:0] and_result;
    assign and_result = a & b;

    assign out_xor = select ? xor_result : and_result;
    assign out_and = select ? and_result : xor_result;
    assign out_not = {8'b0, b_not};

endmodule