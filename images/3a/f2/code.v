module chacha20_core(
    input clk,
    input reset,
    input start,
    input [31:0] key,
    input [31:0] nonce,
    output reg [31:0] output_stream,
    output reg done
);
    reg [31:0] state [0:3]; // Simplified state array
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state[0] <= key;
            state[1] <= nonce;
            state[2] <= 32'h1; // A simple counter value
            state[3] <= 32'h0; // Initialization
            output_stream <= 32'h0;
            done <= 1'b0;
        end else if (start) begin
            // A simple operation simulating the ChaCha20 core
            for (i = 0; i < 4; i = i + 1) begin
                state[i] <= state[i] + (state[(i + 1) % 4] ^ (state[(i + 2) % 4] << 5));
            end
            output_stream <= state[0];
            done <= 1'b1; // Indicate operation is done
        end
    end
endmodule