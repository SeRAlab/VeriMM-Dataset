module top_module(
    input wire [15:0] in1,
    input wire [15:0] in2,
    input wire sel,
    output wire [31:0] out
);assign out = {sel ? in2 : in1, 16'b0, in1};

endmodule