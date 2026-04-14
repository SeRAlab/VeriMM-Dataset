module rnn_cell (
    input [3:0] x,        // 4-bit input
    input [3:0] h_prev,   // 4-bit previous hidden state
    output reg [3:0] h_out // 4-bit output (new hidden state)
);
    always @(*) begin
        h_out = x ^ h_prev; // XOR operation for the output
    end
endmodule