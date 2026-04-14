module cache_replacement (
    input wire clk,
    input wire reset,
    input wire [3:0] address, // 4-bit address for simplicity
    input wire policy_select, // 0 for FIFO, 1 for LRU
    output reg [3:0] replaced_block
);

    reg [3:0] cache [0:3]; // 4 blocks in the cache
    reg [3:0] lru_counter [0:3]; // For LRU policy
    reg [1:0] fifo_pointer; // Pointer for FIFO policy
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 4; i = i + 1) begin
                cache[i] <= 4'b0000; // Initialize cache to 0
                lru_counter[i] <= 0; // Initialize LRU counter
            end
            fifo_pointer <= 0;
            replaced_block <= 4'b0000;
        end else begin
            if (policy_select == 1'b0) begin // FIFO
                replaced_block <= cache[fifo_pointer]; // Replace block
                cache[fifo_pointer] <= address; // Insert new block
                fifo_pointer <= (fifo_pointer + 1) % 4; // Circular increment
            end else begin // LRU
                replaced_block <= cache[0]; // Replace first block
                for (i = 0; i < 3; i = i + 1) begin
                    cache[i] <= cache[i + 1]; // Shift blocks
                    lru_counter[i] <= lru_counter[i + 1]; // Shift LRU counters
                end
                cache[3] <= address; // Insert new block
                lru_counter[3] <= 0; // Reset LRU counter for the new block
                for (i = 0; i < 4; i = i + 1) begin
                    if (i != 3) begin
                        lru_counter[i] <= lru_counter[i] + 1; // Increment counters
                    end
                end
            end
        end
    end
endmodule