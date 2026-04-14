module cache (
    input wire clk,
    input wire reset,
    input wire [3:0] address,
    input wire access, // 1 for access, 0 for miss
    output reg [3:0] cache_out, // output the cached data
    output reg hit, // cache hit indicator
    output reg [3:0] replacement_address // the address of the replaced cache line
);
    reg [3:0] cache [0:3]; // 4 slots cache
    reg [1:0] lru_counter [0:3]; // LRU counter
    reg [1:0] fifo_counter; // FIFO replacement counter
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset cache
            for (i = 0; i < 4; i = i + 1) begin
                cache[i] <= 4'b0000;
                lru_counter[i] <= 2'b00;
            end
            fifo_counter <= 2'b00;
            hit <= 0;
            cache_out <= 4'b0000;
            replacement_address <= 4'b0000;
        end else if (access) begin
            hit <= 0;
            // Check for cache hit
            for (i = 0; i < 4; i = i + 1) begin
                if (cache[i] == address) begin
                    hit <= 1;
                    cache_out <= cache[i];
                    lru_counter[i] <= 2'b11; // set to most recent
                end else if (lru_counter[i] > 0) begin
                    lru_counter[i] <= lru_counter[i] - 1; // decrement LRU counters
                end
            end
            
            if (!hit) begin
                // Cache miss, replace using LRU
                replacement_address = 0;
                for (i = 1; i < 4; i = i + 1) begin
                    if (lru_counter[i] < lru_counter[replacement_address]) begin
                        replacement_address = i;
                    end
                end
                // Replace cache line
                cache[replacement_address] <= address;
                lru_counter[replacement_address] <= 2'b11; // set to most recent
                fifo_counter <= (fifo_counter + 1) % 4; // Update FIFO counter
            end
        end
    end
endmodule