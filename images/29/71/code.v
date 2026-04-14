module rnn_inference (
    input wire clk,
    input wire [3:0] x, // 4-bit input
    output reg [3:0] y  // 4-bit output
);

reg [3:0] state; // Internal state of the RNN

always @(posedge clk) begin
    state <= x + state; // Simple linear transformation
    y <= state;         // Output the current state
end

initial begin
    state = 4'b0000; // Initialize state to zero
end

endmodule