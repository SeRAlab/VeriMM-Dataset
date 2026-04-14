module top_module(
    input [15:0] a,
    input [15:0] b,
    input sub,
    output [15:0] result,
    output carry_out,
    output borrow_out
);wire [15:0] temp_result;
    wire carry_in;
    wire borrow_in;

    assign borrow_in = sub;

    assign temp_result = (sub) ? a - b : a + b;

    assign carry_out = (temp_result[16]) ? 1'b1 : 1'b0;
    assign borrow_out = (sub && (b > a)) ? 1'b1 : 1'b0;

    assign result = temp_result;

endmodule