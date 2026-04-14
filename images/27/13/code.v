module LRU_Cache (  
    input clk,  
    input reset,  
    input [3:0] address,  
    input [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg valid  
);  
    reg [7:0] cache [0:3];  
    reg [1:0] LRU_counter [0:3];  
    reg [1:0] LRU_index;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            valid <= 0;  
            for (i = 0; i < 4; i = i + 1) begin  
                cache[i] <= 8'b0;  
                LRU_counter[i] <= 2'b0;  
            end  
        end else begin  
            if (address < 4) begin  
                valid <= 1;  
                data_out <= cache[address];  
                LRU_counter[address] <= 2'b11; // Mark this block as most recently used  
                for (i = 0; i < 4; i = i + 1) begin  
                    if (i != address) begin  
                        LRU_counter[i] <= LRU_counter[i] - 1;  
                    end  
                end  
            end else begin  
                // Cache miss, replace using LRU  
                LRU_index = 0;  
                for (i = 1; i < 4; i = i + 1) begin  
                    if (LRU_counter[i] < LRU_counter[LRU_index]) begin  
                        LRU_index = i;  
                    end  
                end  
                cache[LRU_index] <= data_in;  
                LRU_counter[LRU_index] <= 2'b11;  
                valid <= 0;  
            end  
        end  
    end  
endmodule