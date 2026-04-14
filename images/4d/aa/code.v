module top_module(
    input address,
    input [7:0] in0,
    input [7:0] in1,
    output [7:0] out
    );assign out = (address == 1'b1) ? in1 : in0;

endmodule