module lru_cache(  
    input clk,  
    input [7:0] address,  
    input [7:0] data_in,  
    input write,  
    output reg [7:0] data_out  
);  
    reg [7:0] cache[3:0];  
    reg [1:0] usage[3:0];  
    integer i, lru_index;  

    always @(posedge clk) begin  
        if (write) begin  
            // Find LRU index  
            lru_index = 0;  
            for (i = 1; i < 4; i = i + 1) begin  
                if (usage[i] < usage[lru_index]) begin  
                    lru_index = i;  
                end  
            end  
            // Replace LRU line  
            cache[lru_index] <= data_in;  
            usage[lru_index] <= 2'b11;  
            for (i = 0; i < 4; i = i + 1) begin  
                if (i != lru_index) usage[i] = usage[i] - 1;  
            end  
        end else begin  
            // Output data for the given address  
            data_out <= cache[address[1:0]];  
            usage[address[1:0]] <= 2'b11;  
            // Update usage counters  
            for (i = 0; i < 4; i = i + 1) begin  
                if (i != address[1:0]) usage[i] = usage[i] - 1;  
            end  
        end  
    end  
endmodule