module top_module(
    input [3:0] in,
    input [1:0] sel,
    output out,
    VPWR,
    VGND,
    VPB,
    VNB
);wire w0, w1;
    wire [1:0] s;
    assign s = {~sel[1], sel[0]};

    // Generic 2-to-1 multiplexer implementation
    assign w0 = (s[0] == 0) ? in[0] : in[1];
    assign w1 = (s[0] == 0) ? in[2] : in[3];

    // Final multiplexing to select between w0 and w1
    assign out = (s[1] == 0) ? w0 : w1;

endmodule