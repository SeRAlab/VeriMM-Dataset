module top_module(
    input clk,
    input [3:0] a,
    input [3:0] b,
    input c,
    output w,
    output x,
    output y,
    output z,
    output final_output
);// 4-bit comparator
    wire equal = (a == b);

    // 3:4 decoder
    wire [3:0] decoder_input = {c, a[3:2]};
    assign w = ~decoder_input[3] & ~decoder_input[2] & ~decoder_input[1] & ~decoder_input[0];
    assign x = ~decoder_input[3] & ~decoder_input[2] & ~decoder_input[1] & decoder_input[0];
    assign y = ~decoder_input[3] & ~decoder_input[2] & decoder_input[1] & ~decoder_input[0];
    assign z = ~decoder_input[3] & ~decoder_input[2] & decoder_input[1] & decoder_input[0];

    // Final output
    assign final_output = equal | w | x | y | z;

endmodule