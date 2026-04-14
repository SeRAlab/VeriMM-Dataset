module top_module(
        input [4:0] in,
        output [31:0] out
    );assign out[4:0] = in;
    assign out[31:5] = {27{1'b0}};
endmodule