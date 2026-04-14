module sha256_simple (
    input clk,
    input reset,
    input [31:0] data_in,
    input start,
    output reg [255:0] hash_out,
    output reg done
);
    reg [255:0] hash; // Internal hash value
    reg [5:0] state;  // State machine for processing
    localparam IDLE = 0, PROCESS = 1, DONE = 2;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hash <= 256'h0;
            done <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        hash <= hash + {224'h0, data_in}; // Simple update for demo
                        state <= PROCESS;
                    end
                end
                PROCESS: begin
                    // Simulate some processing
                    // In a real SHA-256, there would be much more complex operations here
                    hash <= {hash[255:32] ^ data_in, hash[31:0]}; // Simplified operation
                    state <= DONE;
                end
                DONE: begin
                    hash_out <= hash; // Output the final hash
                    done <= 1;
                    state <= IDLE;    // Reset to IDLE for next operation
                end
            endcase
        end
    end
endmodule