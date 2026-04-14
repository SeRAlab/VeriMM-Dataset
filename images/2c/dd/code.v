module cache_replacement #(parameter CACHE_SIZE = 4)(  
    input clk,  
    input reset,  
    input [1:0] policy_sel, // 0 for LRU, 1 for FIFO  
    input [3:0] request, // cache line request  
    output reg [1:0] replace_index  
);  
    reg [3:0] cache [0:CACHE_SIZE-1];  
    reg [2:0] lru_counter [0:CACHE_SIZE-1];  
    reg [1:0] fifo_ptr;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            for (i = 0; i < CACHE_SIZE; i = i + 1) begin  
                cache[i] <= 4'b0;  
                lru_counter[i] <= 3'b0;  
            end  
            fifo_ptr <= 2'b0;  
            replace_index <= 2'b0;  
        end else begin  
            case (policy_sel)  
                2'b00: begin // LRU  
                    replace_index <= 0;  
                    for (i = 1; i < CACHE_SIZE; i = i + 1) begin  
                        if (lru_counter[i] < lru_counter[replace_index])  
                            replace_index <= i;  
                    end  
                    // Update the LRU counters  
                    for (i = 0; i < CACHE_SIZE; i = i + 1) begin  
                        if (cache[i] == request)  
                            lru_counter[i] <= 3'b111; // Recently used  
                        else  
                            lru_counter[i] <= lru_counter[i] - 1;  
                    end  
                end  
                2'b01: begin // FIFO  
                    replace_index <= fifo_ptr;  
                    fifo_ptr <= (fifo_ptr + 1) % CACHE_SIZE;  
                    // Store the request in the cache  
                end  
                default: begin  
                    replace_index <= 2'b0;  
                end  
            endcase  
            // Store the request in the cache  
            cache[replace_index] <= request;  
        end  
    end  
endmodule