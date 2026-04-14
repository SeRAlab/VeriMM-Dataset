module CacheFIFO (
    input wire clk,
    input wire reset,
    input wire [7:0] address, // 8-bit address
    input wire [7:0] data_in, // data to write
    input wire write_enable,    // write signal
    output reg [7:0] data_out,  // data output
    output reg hit              // hit signal
);
    reg [7:0] cache [0:3];      // cache storage (4 blocks)
    reg [1:0] lru [0:3];         // LRU tracking
    integer i, oldest;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize cache and hit signal
            for (i = 0; i < 4; i = i + 1) begin
                cache[i] <= 8'b0;
                lru[i] <= 2'b0;
            end
            hit <= 1'b0;
        end else begin
            hit <= 1'b0; // Reset hit signal for this cycle
            
            // Check for Cache Hit
            for (i = 0; i < 4; i = i + 1) begin
                if (cache[i] == address) begin
                    hit <= 1'b1;
                    data_out <= cache[i]; // Return data from cache
                end
            end
            
            // Cache Write Operation
            if (write_enable) begin
                // Find the oldest block to replace
                oldest = 0;
                for (i = 1; i < 4; i = i + 1) begin
                    if (lru[i] > lru[oldest]) begin
                        oldest = i;
                    end
                end

                // Replace the oldest block
                cache[oldest] <= address; // Store new data in the cache
                lru[oldest] <= 2'b0; // Reset LRU for the new block
                // Update LRU counters
                for (i = 0; i < 4; i = i + 1) begin
                    if (i != oldest) begin
                        lru[i] <= lru[i] + 1; // Increment LRU for other blocks
                    end
                end
            end
        end
    end
endmodule