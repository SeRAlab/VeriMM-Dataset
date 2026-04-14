module top_module(
    input i2,
    input i1,
    input i0,
    output [2:0] o
);wire [2:0] temp;
assign temp = {i2, i1, i0};
assign o = temp;

endmodule