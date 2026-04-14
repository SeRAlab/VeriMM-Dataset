module my_module(
    input [7:0] in,
    output [7:0] out
);

    assign out[7] = ~in[7];
    assign out[6:0] = in[7] ? 8'h7F : 8'h00;

endmodule