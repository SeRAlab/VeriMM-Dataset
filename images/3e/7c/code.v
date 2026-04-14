module cache_lru(
    input wire [3:0] valid_bits, // Valid bits for 4 cache lines
    input wire [1:0] accessed_idx, // Recently accessed index (2 bits for 4 lines)
    output reg [1:0] replace_idx // Index of the line to be replaced
);
    reg [3:0] usage_counter; // 4-bit usage counter for LRU
    integer i;

    always @(*) begin
        // Update usage counter
        usage_counter = valid_bits;

        // Set replace_idx to the least recently used line
        replace_idx = 0;
        for (i = 1; i < 4; i = i + 1) begin
            if (usage_counter[i] < usage_counter[replace_idx]) begin
                replace_idx = i;
            end
        end

        // Update the usage counter
        usage_counter[accessed_idx] = usage_counter[accessed_idx] + 1;
    end
endmodule