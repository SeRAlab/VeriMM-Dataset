module cache_controller(  
    input clk,  
    input [3:0] addr,  
    input control, // 0 for LRU, 1 for FIFO  
    output reg [1:0] replace_line  
);  
    reg [3:0] cache [3:0];  
    reg [1:0] lru_counter [3:0];  
    reg [1:0] fifo_counter;  
    integer i;  

    always @(posedge clk) begin  
        if (control == 0) begin // LRU policy  
            // Check if address is in cache  
            replace_line <= 2'b00; // Default replace line  
            for (i = 0; i < 4; i = i + 1) begin  
                if (cache[i] == addr) begin  
                    // Update LRU counters  
                    lru_counter[i] <= 0;  
                end else begin  
                    lru_counter[i] <= lru_counter[i] + 1;  
                end  
            end  
            // Find the LRU line to replace  
            replace_line <= 0; // Assume line 0 is LRU  
            for (i = 1; i < 4; i = i + 1) begin  
                if (lru_counter[i] > lru_counter[replace_line]) begin  
                    replace_line <= i;  
                end  
            end  
        end else begin // FIFO policy  
            replace_line <= fifo_counter;  
            fifo_counter <= (fifo_counter + 1) % 4;  
        end  
        // Load new address into cache line  
        cache[replace_line] <= addr;  
    end  
endmodule