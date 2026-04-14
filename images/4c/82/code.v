module top_module(
        input  [31:0]in,
        output [31:0]out
    );assign out = {in[29:0], 2'b0};

endmodule