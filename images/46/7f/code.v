module top_module(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input ctrl,
    input vdd,
    input gnd,
    output out
);wire [3:0] and_out;

assign and_out = a & b & c & d;

assign out = (ctrl == 1'b1) ? (~and_out) : and_out;

endmodule