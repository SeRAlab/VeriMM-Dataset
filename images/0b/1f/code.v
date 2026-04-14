module cache_controller (  
    input [1:0] index,  
    input read_write, // 1 for write, 0 for read  
    input [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg [3:0] replace_line  
);  
    reg [7:0] cache [3:0]; // 4 lines of 8-bit data  
    reg [3:0] lru_counter; // LRU counter to track usage  

    integer i;  

    always @(posedge read_write) begin  
        // Handle write operation  
        if (read_write) begin  
            if (lru_counter == 4'b1111) begin  
                // Cache is full, replace the least recently used line  
                replace_line = lru_counter[3:0];  
                cache[replace_line] = data_in;  
                lru_counter = {lru_counter[2:0], 1'b1}; // Update LRU  
            end else begin  
                cache[index] = data_in;  
                lru_counter[index] = 1'b1;  
            end  
        end  
    end  

    always @(negedge read_write) begin  
        // Handle read operation  
        data_out = cache[index];  
        // Update LRU  
        lru_counter[index] = 1'b1;  
    end  
endmodule