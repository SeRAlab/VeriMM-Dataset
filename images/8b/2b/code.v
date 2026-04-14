module top_module(input [2:0] a, input [2:0] b, input sel, output reg [2:0] out);always @*
        if (sel == 1'b0)
            out = a;
        else
            out = b;
endmodule