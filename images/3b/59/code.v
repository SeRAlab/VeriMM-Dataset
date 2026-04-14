module cache_memory (  
    input wire clk,  
    input wire [3:0] address,  
    input wire [7:0] data_in,  
    input wire rw, // 1 for write, 0 for read  
    output reg [7:0] data_out,  
    output reg hit,  
    output reg miss  
);  

    reg [7:0] cache [0:3];  
    reg [3:0] lru_counter [0:3]; // LRU counters  
    reg [1:0] fifo_pointer; // Pointer for FIFO  
    integer i;  

    initial begin  
        for (i = 0; i < 4; i = i + 1) begin  
            cache[i] = 8'b0;  
            lru_counter[i] = 4'b0;  
        end  
        fifo_pointer = 0;  
        hit = 0;  
        miss = 0;  
    end  

    always @(posedge clk) begin  
        if (rw) begin // Write  
            cache[address] = data_in;  
            lru_counter[address] = 4'b0; // Reset the LRU counter  
        end else begin // Read  
            if (cache[address] != 8'b0) begin  
                data_out = cache[address];  
                hit = 1;  
                miss = 0;  
            end else begin  
                data_out = 8'b0;  
                hit = 0;  
                miss = 1;  
                // FIFO replacement policy  
                cache[fifo_pointer] = data_in;  
                fifo_pointer = (fifo_pointer + 1) % 4;  
            end  
            // Update LRU counters  
            for (i = 0; i < 4; i = i + 1) begin  
                if (i != address) lru_counter[i] = lru_counter[i] + 1;  
                else lru_counter[i] = 0;  
            end  
        end  
    end  
endmodule