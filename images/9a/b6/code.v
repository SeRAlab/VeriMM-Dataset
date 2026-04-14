module top_module(output [1:0]out, input [1:0]s);assign
        out[1] = s[1];

    assign
        out[0] = s[0];
endmodule