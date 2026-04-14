module top_module(
        input [7:0] a,
        output [7:0] r
    );assign r = {a[6:0],a[7]};
endmodule