module simple_hash_table (  
    input wire clk,  
    input wire rst,  
    input wire op,  
    input wire [7:0] key,  
    input wire [15:0] value,  
    output reg [15:0] out_value  
);  
    reg [15:0] hash_table [0:15];  
    reg [15:0] retrieved_value;  
    integer index;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            // Initialize the hash table to zero  
            for (index = 0; index < 16; index = index + 1) begin  
                hash_table[index] <= 16'b0;  
            end  
            out_value <= 16'b0;  
        end else begin  
            index = key % 16;  
            if (op == 0) begin  
                // Insert operation  
                hash_table[index] <= value;  
            end else if (op == 1) begin  
                // Retrieve operation  
                out_value <= hash_table[index];  
            end  
        end  
    end  
endmodule