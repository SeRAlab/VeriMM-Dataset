module top_module(
    input [4:0] iData,
    input iEna,
    output [31:0] decode
    );assign decode=((iEna)?(1<<iData):31'b0);endmodule