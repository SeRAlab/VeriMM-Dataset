module top_module(
    input [7:0] address,
    output [7:0] pcAdderResult
);assign pcAdderResult = address + 2;
endmodule