module top_module(
    input [3:0] in,
    output [3:0] out,
    output lost
    );assign out= {{in[2:0]}, 1'b0};
    assign lost= in[3];
endmodule