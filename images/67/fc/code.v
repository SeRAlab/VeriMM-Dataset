module top_module(
    input [3:0] in,
    output out
);wire is_zero_or_fifteen = (in == 4'b0000) || (in == 4'b1111);
    wire is_five_or_ten = (in == 4'b0101) || (in == 4'b1010);

    assign out = is_zero_or_fifteen || is_five_or_ten;

endmodule