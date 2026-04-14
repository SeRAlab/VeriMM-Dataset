module BitwiseNegation (
    input [3:0] in_data,
    output [3:0] out_data
);
    assign out_data = ~in_data;
endmodule