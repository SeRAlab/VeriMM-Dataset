module cache_lru (
    input wire clk,
    input wire reset,
    input wire [7:0] address, // 8-bit address input
    input wire read,          // read operation
    input wire write,         // write operation
    output reg hit,           // cache hit
    output reg [7:0] data_out // data output
);
    reg [7:0] cache [3:0];     // 4 lines of cache
    reg [1:0] lru_counter [3:0]; // Counter for LRU tracking
    reg [1:0] next_lru;        // Next line to replace
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 4; i = i + 1) begin
                cache[i] <= 8'b0;
                lru_counter[i] <= 2'b0;
            end
            hit <= 0;
            data_out <= 8'b0;
        end else begin
            hit <= 0;
            for (i = 0; i < 4; i = i + 1) begin
                if (cache[i] == address) begin
                    hit <= 1;
                    data_out <= cache[i]; // return data
                    lru_counter[i] <= 2'b00; // Reset the LRU counter
                end else begin
                    lru_counter[i] <= lru_counter[i] + 1; // Increment other counters
                end
            end

            if (write && !hit) begin
                // Find the least recently used line
                next_lru = 0;
                for (i = 1; i < 4; i = i + 1) begin
                    if (lru_counter[i] > lru_counter[next_lru]) begin
                        next_lru = i;
                    end
                end
                cache[next_lru] <= address; // Replace the LRU line
                lru_counter[next_lru] <= 2'b00; // Reset LRU counter
            end
        end
    end
endmodule