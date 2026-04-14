module LRU_Cache(
    input wire clk,
    input wire reset,
    input wire [3:0] data_in,
    input wire [1:0] address,
    input wire request, // 1 for write, 0 for read
    output reg hit,
    output reg [3:0] data_out
);
    reg [3:0] cache [0:3]; // 4 cache lines
    reg [1:0] lru [0:3];   // LRU status for cache lines
    integer i;

    // Initialize cache and LRU status
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 4; i = i + 1) begin
                cache[i] <= 4'b0000;
                lru[i] <= i; // Initialize LRU status
            end
            hit <= 0;
            data_out <= 4'b0000;
        end else begin
            if (request) begin // Write operation
                cache[address] <= data_in;
                // Update LRU status
                for (i = 0; i < 4; i = i + 1) begin
                    if (lru[i] < 3) lru[i] <= lru[i] + 1;
                end
                lru[address] <= 0; // Most recently used
            end else begin // Read operation
                if (cache[address] !== 4'b0000) begin
                    hit <= 1;
                    data_out <= cache[address];
                    // Update LRU status
                    for (i = 0; i < 4; i = i + 1) begin
                        if (lru[i] < 3) lru[i] <= lru[i] + 1;
                    end
                    lru[address] <= 0; // Most recently used
                end else begin
                    hit <= 0;
                    data_out <= 4'b0000; // Cache miss
                end
            end
        end
    end
endmodule