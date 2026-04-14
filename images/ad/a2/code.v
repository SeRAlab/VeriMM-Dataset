module top_module(
    input [7:0] a,
    input [7:0] b,
    input add,
    input sub,
    output [7:0] result
);wire [7:0] add_result;
    wire [7:0] sub_result;

    assign add_result = a + b;
    assign sub_result = a - b;

    assign result = add ? add_result : sub ? sub_result : 8'b0;

endmodule