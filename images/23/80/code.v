module CacheReplacement(
    input wire clk,
    input wire reset,
    input wire [3:0] addr, // Cache address
    input wire policy, // 0 for FIFO, 1 for LRU
    output reg [1:0] replace_index // Index of cache line to replace
);
    reg [1:0] fifo_counter; // For FIFO replacement
    reg [3:0] lru_counter [3:0]; // For LRU replacement
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            replace_index <= 2'b00;
            fifo_counter <= 2'b00;
            for (i = 0; i < 4; i = i + 1) begin
                lru_counter[i] <= 4'b0;
            end
        end else begin
            if (policy) begin // LRU
                replace_index <= 0;
                for (i = 1; i < 4; i = i + 1) begin
                    if (lru_counter[i] < lru_counter[replace_index]) begin
                        replace_index <= i;
                    end
                end
                lru_counter[replace_index] <= addr; // Update the LRU counter
                for (i = 0; i < 4; i = i + 1) begin
                    lru_counter[i] <= lru_counter[i] + 1; // Increment usage
                end
                lru_counter[replace_index] <= 0; // Reset the used line
            end else begin // FIFO
                replace_index <= fifo_counter; // Replace the next line in FIFO order
                fifo_counter <= fifo_counter + 1; // Increment FIFO counter
                if (fifo_counter == 3) begin
                    fifo_counter <= 0; // Wrap around
                end
            end
        end
    end
endmodule