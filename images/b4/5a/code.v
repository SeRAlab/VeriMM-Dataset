module top_module(
    input [5:1] rt,rd,
    input selectCode,
    output [5:1] out
    );assign out=(selectCode == 1'b0) ? rt : rd;

endmodule