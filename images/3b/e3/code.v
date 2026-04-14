module conv2x2(
    input wire [7:0] in00, in01, in10, in11, // 2x2 input matrix
    input wire [7:0] k00, k01, k10, k11,     // 2x2 kernel matrix
    output wire [15:0] out                    // single output value
);
    assign out = (in00 * k00) + (in01 * k01) + (in10 * k10) + (in11 * k11);
endmodule