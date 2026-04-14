module cache_controller(
    input clk,
    input rst,
    input wr_en,
    input [3:0] address,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg [3:0] cache_status,  // 4 bits for 4 cache lines
    input select_policy // 0 for LRU, 1 for FIFO
);

    reg [7:0] cache [0:3]; // cache memory
    reg [1:0] lru_counter [0:3]; // LRU counter
    reg [1:0] fifo_pointer; // FIFO pointer
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 4; i = i + 1) begin
                cache[i] <= 8'b0;
                lru_counter[i] <= 2'b0;
            end
            fifo_pointer <= 2'b0;
            cache_status <= 4'b0000;
            data_out <= 8'b0;
        end else begin
            if (wr_en) begin
                if (select_policy == 0) begin // LRU
                    // Find least recently used line
                    // Update data and counters
                    // (Implementation of LRU logic)
                end else begin // FIFO
                    // Replace cache line using FIFO policy
                    // Update cache and pointer
                    // (Implementation of FIFO logic)
                end
            end else begin
                // Read operation
                // Output data from cache
                data_out <= cache[address];
                cache_status <= cache_status; // maintain status
            end
        end
    end
endmodule