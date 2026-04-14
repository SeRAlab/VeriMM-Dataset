module cache_memory(
    input clk,
    input reset,
    input [3:0] address,
    input [7:0] data_in,
    input rw, // 1 for write, 0 for read
    input sel, // 0 for LRU, 1 for FIFO
    output reg hit,
    output reg miss,
    output reg [7:0] data_out
);
    reg [7:0] cache [3:0]; // cache with 4 blocks
    reg [1:0] lru_counter [3:0]; // LRU counters
    reg [1:0] fifo_pointer; // pointer for FIFO
    reg [3:0] valid; // valid bits for cache

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            valid <= 4'b0000;
            fifo_pointer <= 2'b00;
            for (i = 0; i < 4; i = i + 1) begin
                cache[i] <= 8'b0;
                lru_counter[i] <= 2'b0;
            end
        end else begin
            if (rw == 1) begin // Write operation
                if (valid[fifo_pointer] == 1'b0) begin // Cache miss
                    miss <= 1;
                    valid[fifo_pointer] <= 1;
                end else begin
                    miss <= 0;
                end
                cache[fifo_pointer] <= data_in;
                fifo_pointer <= fifo_pointer + 1'b1; // Update FIFO pointer

                if (sel == 0) begin // Update LRU counters
                    for (i = 0; i < 4; i = i + 1) begin
                        if (valid[i] == 1'b1) begin
                            lru_counter[i] <= lru_counter[i] + 1;
                        end
                    end
                    lru_counter[fifo_pointer] <= 0; // Reset current block
                end

            end else begin // Read operation
                if (valid[address] == 1'b1) begin // Cache hit
                    hit <= 1;
                    miss <= 0;
                    data_out <= cache[address];
                    if (sel == 0) begin // Update LRU counters
                        for (i = 0; i < 4; i = i + 1) begin
                            if (valid[i] == 1'b1) begin
                                lru_counter[i] <= lru_counter[i] + 1;
                            end
                        end
                        lru_counter[address] <= 0; // Reset current block
                    end
                end else begin // Cache miss
                    hit <= 0;
                    miss <= 1;
                    data_out <= 8'b0; // No data
                end
            end
        end
    end
endmodule