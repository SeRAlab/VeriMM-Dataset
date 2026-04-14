module cache_replacement(
    input wire clk,
    input wire reset,
    input wire [1:0] policy_select, // 0 = LRU, 1 = FIFO
    input wire request,
    output reg [3:0] replaced_line // 4-bit output for 16 cache lines
);
    reg [3:0] lru_counter [0:15]; // For LRU
    reg [3:0] fifo_queue [0:15]; // For FIFO
    integer i, fifo_index;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1) begin
                lru_counter[i] = 0;
                fifo_queue[i] = i; // Initialize FIFO queue
            end
            fifo_index = 0;
            replaced_line = 0;
        end else if (request) begin
            if (policy_select == 2'b00) begin // LRU
                replaced_line = 0; // Find the least recently used line
                for (i = 1; i < 16; i = i + 1) begin
                    if (lru_counter[i] < lru_counter[replaced_line]) begin
                        replaced_line = i;
                    end
                end
                lru_counter[replaced_line] = 0; // Reset this line's counter
                for (i = 0; i < 16; i = i + 1) begin
                    if (i != replaced_line) lru_counter[i] = lru_counter[i] + 1; // Update other counters
                end
            end else if (policy_select == 2'b01) begin // FIFO
                replaced_line = fifo_queue[fifo_index];
                fifo_index = (fifo_index + 1) % 16; // Circular increment
            end
        end
    end
endmodule