module top_module(
    input clk,
    input in0,
    input in1,
    input in2,
    output reg out
);reg tmp0, tmp1, tmp2, tmp3;

    // Compute tmp0 = in0 xor in1
    xor x0(tmp0, in0, in1);

    // Compute tmp1 = in0 xor in2
    xor x1(tmp1, in0, in2);

    // Compute tmp2 = in1 xor in2
    xor x2(tmp2, in1, in2);

    // Compute tmp3 = tmp0 xor tmp1
    xor x3(tmp3, tmp0, tmp1);

    // Compute out = tmp3 xor tmp2
    xor x4(out, tmp3, tmp2);

endmodule