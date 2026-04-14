module cache_system #(parameter CACHE_SIZE = 4, parameter ADDRESS_WIDTH = 4) (  
    input clk,  
    input reset,  
    input [ADDRESS_WIDTH-1:0] address,  
    input read,  
    input policy_select,  // 0 for FIFO, 1 for LRU  
    output reg hit,  
    output reg [ADDRESS_WIDTH-1:0] data_out  
);  
    reg [ADDRESS_WIDTH-1:0] cache [0:CACHE_SIZE-1];  
    reg [CACHE_SIZE-1:0] valid;  
    reg [CACHE_SIZE-1:0] lru_counter;  
    integer i;  
    integer lru_index;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            valid <= 0;  
            hit <= 0;  
            for (i = 0; i < CACHE_SIZE; i = i + 1)  
                cache[i] <= 0;  
        end else if (read) begin  
            hit <= 0;  
            for (i = 0; i < CACHE_SIZE; i = i + 1) begin  
                if (valid[i] && (cache[i] == address)) begin  
                    hit <= 1;  
                    data_out <= cache[i];  
                    if (policy_select) begin  
                        lru_counter[i] <= 1;  // Update LRU counter  
                    end  
                end  
            end  
            if (!hit) begin  
                if (policy_select) begin  
                    // LRU Replacement  
                    lru_index = 0;  
                    for (i = 1; i < CACHE_SIZE; i = i + 1) begin  
                        if (lru_counter[i] < lru_counter[lru_index])  
                            lru_index = i;  
                    end  
                    cache[lru_index] <= address;  
                    lru_counter[lru_index] <= 1;  
                end else begin  
                    // FIFO Replacement  
                    for (i = 1; i < CACHE_SIZE; i = i + 1) begin  
                        cache[i-1] <= cache[i];  
                    end  
                    cache[CACHE_SIZE-1] <= address;  
                end  
                valid[lru_index] <= 1;  
            end  
        end  
    end  
endmodule