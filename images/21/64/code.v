module cache_replacement (
    input clk,
    input reset,
    input [7:0] cache_in,
    input cache_req,   // 1 for read, 0 for write
    input policy,      // 0 for LRU, 1 for FIFO
    output reg [7:0] cache_out,
    output reg cache_hit
);

    parameter CACHE_SIZE = 4; // 4 entries cache
    reg [7:0] cache_data [0:CACHE_SIZE-1];
    reg [CACHE_SIZE-1:0] valid; // Valid bits for cache entries
    reg [CACHE_SIZE-1:0] lru_counter; // LRU counter
    integer i, lru_index;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < CACHE_SIZE; i = i + 1) begin
                cache_data[i] <= 8'b0;
                valid[i] <= 1'b0;
            end
            cache_hit <= 0;
            lru_counter <= 0;
        end else begin
            cache_hit <= 0; // Default hit signal
            if (cache_req) begin // Read request
                for (i = 0; i < CACHE_SIZE; i = i + 1) begin
                    if (valid[i] && cache_data[i] == cache_in) begin
                        cache_out <= cache_data[i];
                        cache_hit <= 1;
                        if (policy == 0) begin // LRU update
                            lru_counter <= {lru_counter[CACHE_SIZE-2:0], 1'b1};
                            lru_counter[i] <= 0; // Reset the LRU for hit
                        end
                    end
                end
            end else begin // Write request
                if (!cache_hit) begin
                    // Find an empty slot or replace using selected policy
                    if (policy == 0) begin // LRU replacement
                        lru_index = 0;
                        for (i = 1; i < CACHE_SIZE; i = i + 1) begin
                            if (lru_counter[i]) lru_index = i; // Find the LRU
                        end
                    end else begin // FIFO replacement
                        lru_index = (lru_counter[0] == 0) ? 0 : (lru_counter[0] + 1) % CACHE_SIZE;
                    end
                    cache_data[lru_index] <= cache_in;
                    valid[lru_index] <= 1'b1;
                    lru_counter[lru_index] <= 1'b1; // Mark this entry as recently used
                end
            end
        end
    end
endmodule