module cache_lru (  
    input clk,  
    input reset,  
    input [3:0] address,  
    input [7:0] write_data,  
    input read,  
    input write_enable,  
    output reg [7:0] read_data,  
    output reg hit  
);  
    reg [7:0] cache [0:3];  
    reg [1:0] lru [0:1];  
    reg [1:0] tags [0:3];  
    reg [1:0] lru_counter;  
    integer i;  
      
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            for (i = 0; i < 4; i = i + 1) begin  
                cache[i] = 8'b0;  
                tags[i] = 2'b0;  
            end  
            lru_counter = 2'b0;  
        end else begin  
            if (write_enable) begin  
                if (tags[address[3:2]] == lru_counter) begin  
                    cache[address[3:2]] = write_data;  
                    hit = 1;  
                end else begin  
                    cache[lru_counter] = write_data;  
                    tags[lru_counter] = address[3:2];  
                    hit = 0;  
                end  
            end  
            if (read) begin  
                read_data = cache[address[3:2]];  
                hit = (tags[address[3:2]] == address[3:2]) ? 1 : 0;  
            end  
            lru_counter = (lru_counter + 1) % 4;  
        end  
    end  
endmodule