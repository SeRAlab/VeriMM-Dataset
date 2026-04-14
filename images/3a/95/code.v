module bitwise_not(
    input  [4:0] in_data,
    output [4:0] out_data
);
    assign out_data = ~in_data;
endmodule