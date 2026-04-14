module chacha20_update (
    input wire clk,
    input wire reset,
    input wire [31:0] key,
    input wire [31:0] nonce,
    output reg [31:0] state_out
);
    reg [31:0] state_a, state_b;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_a <= key; // Initialize state with key
            state_b <= nonce; // Initialize state with nonce
            state_out <= 0;
        end else begin
            // Applying quarter round operation
            state_a <= state_a + state_b; 
            state_b <= {state_b[30:0], state_b[31]}; // Rotate left by 1
            state_out <= state_a ^ state_b; // Output the XOR of both states
        end
    end
endmodule