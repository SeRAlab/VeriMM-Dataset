module chacha20_simple (
    input wire clk,
    input wire reset,
    input wire [31:0] key,
    output reg [31:0] output_stream
);
    reg [31:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= key; // Initialize state with the key
        end else begin
            // Simple transformation (a placeholder for actual ChaCha20 rounds)
            state <= state + 32'h1; // Increment state for demonstration purposes
        end
    end

    always @(posedge clk) begin
        output_stream <= state; // Output the current state
    end
endmodule