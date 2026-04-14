module top_module(
    input [7:0] log2N,
    output [31:0] N
    );assign N = (1<<log2N);
endmodule