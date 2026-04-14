module top_module(
    input [7:0] input_a,
    input [7:0] input_b,
    output [7:0] sum_out,
    output overflow
);wire [8:0] sum_tmp;
    assign sum_tmp = {1'b0, input_a} + {1'b0, input_b}; // add inputs with carry-in of 0

    assign sum_out = sum_tmp[7:0]; // output lower 8 bits of sum
    assign overflow = sum_tmp[8]; // output overflow bit

endmodule