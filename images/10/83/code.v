module cache_memory (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] addr,  
    input wire access, // Signal to trigger access to cache  
    output reg hit,  
    output reg [7:0] cache_line0,  
    output reg [7:0] cache_line1,  
    output reg [7:0] cache_line2,  
    output reg [7:0] cache_line3  
);  
    reg [7:0] cache [3:0];  
    reg [1:0] lru_counter [3:0];  
    integer i;  
    integer lru_index;  
    initial begin  
        hit = 0;  
        for (i = 0; i < 4; i = i + 1) begin  
            cache[i] = 8'b0;  
            lru_counter[i] = 2'b0;  
        end  
    end  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            hit = 0;  
            for (i = 0; i < 4; i = i + 1) begin  
                cache[i] = 8'b0;  
                lru_counter[i] = 2'b0;  
            end  
        end else if (access) begin  
            hit = 0;  
            for (i = 0; i < 4; i = i + 1) begin  
                if (cache[i] == addr) begin  
                    hit = 1;  
                    lru_counter[i] = 2'b11; // Update LRU on hit  
                end else begin  
                    lru_counter[i] = lru_counter[i] - 1;  
                end  
            end  
            if (!hit) begin  
                lru_index = 0;  
                for (i = 1; i < 4; i = i + 1) begin  
                    if (lru_counter[i] < lru_counter[lru_index])  
                        lru_index = i;  
                end  
                cache[lru_index] = addr;  
                lru_counter[lru_index] = 2'b11; // Reset LRU for new entry  
            end  
            cache_line0 = cache[0];  
            cache_line1 = cache[1];  
            cache_line2 = cache[2];  
            cache_line3 = cache[3];  
        end  
    end  
endmodule