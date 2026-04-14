module top_module(
    input [3:0] A,
    input [3:0] B,
    input mode,
    output [3:0] F,
    output Cout
);wire [3:0] sum;
    wire [3:0] twos_comp_B;

    assign twos_comp_B = (~B + 1);

    // Adder
    assign sum = A + (mode ? twos_comp_B : B);

    assign F = sum;
    assign Cout = (mode ? ~sum[3] : sum[3]);

endmodule