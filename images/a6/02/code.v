module top_module(
    input   [29:0]a0,
    input   [29:0]a1,
    input   choose,
    output  [29:0]out
    );assign out = (choose==1'b0) ? a0 : a1;
endmodule