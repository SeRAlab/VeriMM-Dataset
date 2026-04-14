module lru_cache (
    input clk,
    input reset,
    input [3:0] data_in,
    input load,
    output reg hit,
    output reg [3:0] cache_out
);
    reg [3:0] cache [0:3]; // 4-slot cache
    reg [1:0] lru_counter [0:3]; // LRU counters for each slot
    integer i, lru_index;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 4; i = i + 1) begin
                cache[i] <= 4'b0000; 
                lru_counter[i] <= 2'b00; 
            end
            hit <= 0; 
            cache_out <= 4'b0000;
        end else if (load) begin
            hit <= 0; 
            // Check for hit
            for (i = 0; i < 4; i = i + 1) begin
                if (cache[i] == data_in) begin
                    hit <= 1; 
                    lru_counter[i] <= 2'b11; // Most recently used
                    cache_out <= cache[i]; 
                end else begin
                    lru_counter[i] <= lru_counter[i] - 1; // Decrease LRU counter
                end
            end
            
            // If not hit, replace the LRU entry
            if (!hit) begin
                lru_index = 0;
                for (i = 1; i < 4; i = i + 1) begin
                    if (lru_counter[i] < lru_counter[lru_index]) begin
                        lru_index = i;
                    end
                end
                cache[lru_index] <= data_in; 
                lru_counter[lru_index] <= 2'b11; // Reset LRU counter for this entry
            end
        end
    end
endmodule