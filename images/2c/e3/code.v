module rnn_cell (
    input clk,
    input rst,
    input [3:0] x, // input vector
    input [3:0] h_prev, // previous hidden state
    output reg [3:0] h_new // new hidden state
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        h_new <= 4'b0000; // reset hidden state
    end else begin
        // Simple state update: h_new = activation(W * x + U * h_prev)
        // For simplicity, we will use a basic equation:
        // h_new = (x + h_prev) > 4'b1000 ? 4'b1111 : 4'b0000; // simple threshold activation
        h_new <= (x + h_prev) > 4'b1000 ? 4'b1111 : 4'b0000;
    end
end

endmodule