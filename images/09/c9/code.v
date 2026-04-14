module SHA256_Hash(
    input clk,
    input reset,
    input enable,
    input [255:0] message,
    input message_valid,
    output reg [255:0] hash,
    output reg hash_valid
);

reg [2:0] state;
parameter IDLE = 3'd0, PROCESS = 3'd1, FINISH = 3'd2;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        hash <= 256'd0;
        hash_valid <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (enable && message_valid) begin
                    // Start processing the message
                    // Hash computation logic goes here (simplified for this example)
                    hash <= message ^ 256'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5; // Example operation
                    state <= PROCESS;
                end
            end
            PROCESS: begin
                // Process state (for this simple example, we go directly to finish)
                state <= FINISH;
            end
            FINISH: begin
                hash_valid <= 1'b1; // Signal that the hash is valid
                state <= IDLE; // Go back to IDLE for next input
            end
        endcase
    end
end

endmodule