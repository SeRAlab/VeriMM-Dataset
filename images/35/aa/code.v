module CSPRNG(
    input clk,
    input rst,
    input [3:0] tap, // tap positions for feedback
    output reg random_bit
);
    reg [15:0] state; // 16-bit LFSR state

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 16'hACE1; // Initial seed value
        end else begin
            random_bit <= state[0]; // Output the least significant bit
            // Feedback calculation based on tap positions
            state <= {state[14:0], (state[15] ^ state[tap[3:0]])};
        end
    end
endmodule